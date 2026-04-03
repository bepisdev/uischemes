# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# ─── Tags ────────────────────────────────────────────────────────────────────

tag_names = [ "Dark", "Light", "Minimal", "Pastel", "Vibrant", "Monochrome" ]

tags = tag_names.each_with_object({}) do |name, hash|
  hash[name] = Tag.find_or_create_by!(name: name)
end

# ─── Palettes ─────────────────────────────────────────────────────────────────

palettes_data = [
  {
    name:           "Midnight",
    description:    "A deep, near-black palette with cool indigo undertones. Clean and focused — ideal for developer tools, dashboards, and dark-mode interfaces.",
    primary_hex:    "#7c6af7",
    secondary_hex:  "#3d3b6e",
    accent_hex:     "#a78bfa",
    background_hex: "#0d0d1a",
    surface_hex:    "#14141f",
    text_hex:       "#e8e6f9",
    tags:           [ "Dark", "Minimal" ]
  }
]

palettes_data.each do |data|
  tag_list = data.delete(:tags)
  palette = Palette.find_or_create_by!(name: data[:name]) do |p|
    p.assign_attributes(data)
  end

  tag_list.each do |tag_name|
    palette.tags << tags[tag_name] unless palette.tags.include?(tags[tag_name])
  end
end

puts "Seeded #{Palette.count} palette(s) and #{Tag.count} tag(s)."
