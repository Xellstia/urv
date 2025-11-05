class AddSourceToWorkItems < ActiveRecord::Migration[7.2]
  def change
    add_column :work_items, :source, :string
  end
end
