class PalettesController < ApplicationController
  def index
    @tags = Tag.order(:name)
    @active_tag = params[:tag].presence

    @palettes = if @active_tag
      Palette.with_tag(@active_tag).includes(:tags)
    else
      Palette.includes(:tags).all
    end
  end
end
