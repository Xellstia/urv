class TempoAttributePreference < ApplicationRecord
  belongs_to :user

  enum category: {
    work_kind: "work_kind",
    cs_action: "cs_action",
    cs_is: "cs_is"
  }

  validates :category, presence: true

  def visible?(external_id)
    visible_ids.blank? || visible_ids.include?(external_id)
  end
end
