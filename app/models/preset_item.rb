class PresetItem < ApplicationRecord
  belongs_to :preset

  enum :system, { tempo: "tempo", yaga: "yaga", other: "other" }

  validates :system, presence: true
  validates :minutes_spent, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end

