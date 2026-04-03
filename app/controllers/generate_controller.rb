class GenerateController < ApplicationController
  MOODS      = PaletteGeneratorService::MOODS
  HARMONIES  = PaletteGeneratorService::HARMONIES
  MAX_VARIATIONS = PaletteGeneratorService::MAX_VARIATIONS

  def index
    @base_hex   = params[:base_hex].presence
    @mood       = params[:mood].presence
    @harmony    = params[:harmony].presence
    @variations = (params[:variations].presence || 1).to_i.clamp(1, MAX_VARIATIONS)

    return unless @base_hex && @mood && @harmony

    service = PaletteGeneratorService.new(
      base_hex:   @base_hex,
      mood:       @mood,
      harmony:    @harmony,
      variations: @variations
    )
    @palettes = service.call
  rescue ArgumentError => e
    @error = e.message
  end
end
