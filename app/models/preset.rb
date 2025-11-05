class Preset < ApplicationRecord
  belongs_to :user
  has_many :preset_items, dependent: :destroy

  validates :weekday, inclusion: { in: 1..7 }
  validates :name, presence: true
end