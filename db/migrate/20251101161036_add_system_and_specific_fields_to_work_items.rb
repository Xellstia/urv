class AddSystemAndSpecificFieldsToWorkItems < ActiveRecord::Migration[7.2]
  def change
    add_column :work_items, :system, :string
    add_column :work_items, :tempo_work_kind, :string
    add_column :work_items, :tempo_cs_action, :string
    add_column :work_items, :tempo_cs_is, :string
    add_column :work_items, :yaga_workspace, :string
    add_column :work_items, :yaga_work_kind, :string
    add_column :work_items, :title, :string
  end
end
