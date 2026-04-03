class Tag < ApplicationRecord
  has_many :palette_tags, dependent: :destroy
  has_many :palettes, through: :palette_tags

  before_validation :generate_slug

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank?
  end
end
