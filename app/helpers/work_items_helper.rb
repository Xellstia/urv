# app/helpers/work_items_helper.rb
module WorkItemsHelper
  # Возвращает "код задачи" для карточки (Tempo/Jaga) из доступных полей.
  # Порядок важен: сначала самые вероятные, затем запасные варианты.
  def display_work_item_code(item)
    candidates = [
      item.try(:issue_key),
      item.try(:task_key),
      item.try(:key),
      item.try(:code),
      item.try(:number),
      item.try(:external_id),
      item.try(:title) # как fallback
    ]

    candidates.compact.map(&:to_s).map(&:strip).reject(&:empty?).first
  end
end
