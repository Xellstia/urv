class CreatePresetItems < ActiveRecord::Migration[7.2]
  def change
    create_table :preset_items do |t|
      t.references :preset, null: false, foreign_key: true
      t.string :system
      t.string :issue_key
      t.text :description
      t.integer :minutes_spent
      t.string :tempo_work_kind
      t.string :tempo_cs_action
      t.string :tempo_cs_is
      t.string :yaga_workspace
      t.string :yaga_work_kind

      t.timestamps
    end
  end
end
