class WorkItem < ApplicationRecord
  belongs_to :user

  enum :state, { incomplete: 0, draft: 1, synced: 2 }

  validates :date, presence: true
  validates :minutes_spent, numericality: { greater_than_or_equal_to: 0 }

  # Простейшая «мягкая» проверка: если нет ни issue ни project — считаем invalid
  before_validation :autofill_state

  private

  def autofill_state
    if minutes_spent.to_i <= 0 || (issue_key.blank? && project_key.blank?)
      self.state = :incomplete
    else
      self.state ||= :draft
    end
  end
end
