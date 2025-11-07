class CreateTemplateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :template_categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.boolean :collapsed

      t.timestamps
    end
  end
end
