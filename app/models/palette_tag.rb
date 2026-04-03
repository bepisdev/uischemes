class PaletteTag < ApplicationRecord
  belongs_to :palette
  belongs_to :tag

  validates :palette_id, uniqueness: { scope: :tag_id }
end
