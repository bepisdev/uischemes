class CreatePalettes < ActiveRecord::Migration[8.1]
  def change
    create_table :palettes do |t|
      t.string :name
      t.text :description
      t.string :primary_hex
      t.string :secondary_hex
      t.string :accent_hex
      t.string :background_hex
      t.string :surface_hex
      t.string :text_hex

      t.timestamps
    end
  end
end
