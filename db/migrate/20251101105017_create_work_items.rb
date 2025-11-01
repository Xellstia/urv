class CreateWorkItems < ActiveRecord::Migration[7.2]
  def change
    create_table :work_items do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :minutes_spent
      t.string :project_key
      t.string :issue_key
      t.text :description
      t.integer :state

      t.timestamps
    end
  end
end
