class TempoWorkAttribute < ApplicationRecord
  enum category: {
    work_kind: "work_kind",
    cs_action: "cs_action",
    cs_is: "cs_is"
  }, _suffix: :category

  validates :external_id, presence: true, uniqueness: true
  validates :name, :category, presence: true
end
