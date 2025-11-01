# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Создаём пользователя, если его нет (используем первого зарегистрированного, если есть)
user = User.first || User.create!(email: "demo@example.com", password: "password", password_confirmation: "password")

start = Date.current.beginning_of_week(:monday)

samples = [
  { title: "Planning",   project_key: "APP",  issue_key: "APP-123", description: "Брейншторм", minutes: 90, state: :draft  },
  { title: "Analysis",   project_key: "OPS",  issue_key: "OPS-55",  description: "Ресерч",     minutes: 60, state: :synced },
  { title: "Testing",    project_key: nil,    issue_key: nil,       description: "Нет issue → ошибка", minutes: 45, state: :incomplete },
]

(0..6).each do |i|
  day = start + i
  samples.each do |s|
    WorkItem.create!(
      user: user,
      date: day,
      minutes_spent: s[:minutes],
      project_key: s[:project_key],
      issue_key: s[:issue_key],
      description: "#{s[:title]} — #{s[:description]}",
      state: WorkItem.states[s[:state]]
    )
  end
end

puts "Seeded #{WorkItem.count} work items for #{user.email}"