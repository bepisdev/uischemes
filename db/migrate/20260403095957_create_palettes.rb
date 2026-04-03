class CreatePalettes < ActiveRecord::Migration[8.1]
  def change
    create_table :palettes do |t|
      t.string :name,           null: false
      t.text   :description
      t.string :primary_hex,    null: false, limit: 7
      t.string :secondary_hex,  null: false, limit: 7
      t.string :accent_hex,     null: false, limit: 7
      t.string :background_hex, null: false, limit: 7
      t.string :surface_hex,    null: false, limit: 7
      t.string :text_hex,       null: false, limit: 7

      t.timestamps
    end

    add_index :palettes, :name, unique: true
  end
end
