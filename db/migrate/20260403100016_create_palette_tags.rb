class CreatePaletteTags < ActiveRecord::Migration[8.1]
  def change
    create_table :palette_tags do |t|
      t.references :palette, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
