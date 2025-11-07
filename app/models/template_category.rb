class TemplateCategory < ApplicationRecord
  belongs_to :user
  has_many :template_cards, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true

  scope :ordered, -> { order(:id) }
end
