class Palette < ApplicationRecord
  HEX_FORMAT = /\A#[0-9A-Fa-f]{6}\z/

  has_many :palette_tags, dependent: :destroy
  has_many :tags, through: :palette_tags

  validates :name, presence: true, uniqueness: true
  validates :primary_hex, :secondary_hex, :accent_hex,
            :background_hex, :surface_hex, :text_hex,
            presence: true, format: { with: HEX_FORMAT, message: "must be a valid 6-digit hex colour (e.g. #1a2b3c)" }

  scope :with_tag, ->(slug) { joins(:tags).where(tags: { slug: slug }) }

  def colour_roles
    {
      primary:    primary_hex,
      secondary:  secondary_hex,
      accent:     accent_hex,
      background: background_hex,
      surface:    surface_hex,
      text:       text_hex
    }
  end

  def to_css
    lines = colour_roles.map { |role, hex| "  --color-#{role}: #{hex};" }
    ":root {\n#{lines.join("\n")}\n}"
  end

  def to_tailwind_config
    lines = colour_roles.map { |role, hex| "        #{role}: '#{hex}'," }
    "module.exports = {\n  theme: {\n    extend: {\n      colors: {\n#{lines.join("\n")}\n      },\n    },\n  },\n}"
  end

  def to_js_module
    lines = colour_roles.map { |role, hex| "  #{role}: '#{hex}'," }
    "export const palette = {\n#{lines.join("\n")}\n};"
  end
end
