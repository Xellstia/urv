class CreateTempoAttributePreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :tempo_attribute_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category, null: false
      t.jsonb :visible_ids, default: nil

      t.timestamps
    end

    add_index :tempo_attribute_preferences, [:user_id, :category], unique: true, name: "index_tempo_attribute_prefs_on_user_and_category"
  end
end
