class TemplateCard < ApplicationRecord
  belongs_to :template_category

  SYSTEMS = %w[tempo yaga].freeze
  validates :system, inclusion: { in: SYSTEMS }
  validates :minutes_spent, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  delegate :user, to: :template_category
end
