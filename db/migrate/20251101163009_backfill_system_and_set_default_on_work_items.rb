class BackfillSystemAndSetDefaultOnWorkItems < ActiveRecord::Migration[7.2]
  def up
    # Проставим tempo там, где пусто
    execute "UPDATE work_items SET system = 'tempo' WHERE system IS NULL OR system = ''"

    # Дефолт и NOT NULL
    change_column_default :work_items, :system, "tempo"
    change_column_null :work_items, :system, false
  end

  def down
    change_column_null :work_items, :system, true
    change_column_default :work_items, :system, nil
  end
end
