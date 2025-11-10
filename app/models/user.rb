class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :work_items, dependent: :destroy
  has_many :template_categories, dependent: :destroy
  has_many :tempo_attribute_preferences, dependent: :destroy

  encrypts :tempo_password
  encrypts :yaga_password
  encrypts :otrs_password

  def tempo_default(attribute)
    tempo_defaults[attribute.to_s]
  end

  def update_tempo_default(attribute, value)
    update!(tempo_defaults: tempo_defaults.merge(attribute.to_s => value))
  end
end
