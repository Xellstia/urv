class CreateTempoWorkAttributes < ActiveRecord::Migration[7.2]
  def change
    create_table :tempo_work_attributes do |t|
      t.integer :external_id, null: false
      t.string :name
      t.string :key
      t.string :value
      t.string :category
      t.datetime :synced_at

      t.timestamps
    end

    add_index :tempo_work_attributes, :external_id, unique: true
  end
end
