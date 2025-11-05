class WorkItem < ApplicationRecord
  belongs_to :user

  enum :state,  { incomplete: 0, draft: 1, synced: 2 }
  enum :system, { tempo: "tempo", yaga: "yaga", otrs: "otrs", other: "other" }

  validates :date, presence: true
  validates :minutes_spent, numericality: { greater_than_or_equal_to: 0 }

  before_validation :autofill_state
  before_validation :set_default_system

  private

  def autofill_state
    if minutes_spent.to_i <= 0 || (issue_key.blank? && project_key.blank?)
      self.state = :incomplete
    else
      self.state ||= :draft
    end
  end

  def set_default_system
    self.system ||= "tempo"
  end
end

