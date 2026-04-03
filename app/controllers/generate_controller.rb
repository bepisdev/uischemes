class GenerateController < ApplicationController
  MOODS     = PaletteGeneratorService::MOODS
  HARMONIES = PaletteGeneratorService::HARMONIES

  def index
    @base_hex = params[:base_hex].presence
    @mood     = params[:mood].presence
    @harmony  = params[:harmony].presence

    return unless @base_hex && @mood && @harmony

    service = PaletteGeneratorService.new(
      base_hex: @base_hex,
      mood:     @mood,
      harmony:  @harmony
    )
    @palette = service.call
  rescue ArgumentError => e
    @error = e.message
  end
end
