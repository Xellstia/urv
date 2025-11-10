# db/seeds.rb

# 1) Возьмём пользователя для сидов
user =
  User.find_by(email: "demo@example.com") ||
  User.first

unless user
  # если совсем нет пользователей — создадим тестового
  user = User.create!(email: "demo@example.com", password: "password", password_confirmation: "password")
  puts "Created user #{user.email} / password"
end

unless user.admin?
  user.update!(admin: true)
  puts "Granted admin rights to #{user.email}"
end

# 2) Создадим пресеты по будням, если их ещё нет
unless Preset.where(user_id: user.id).exists?
  names = { 1 => "Понедельник", 2 => "Вторник", 3 => "Среда", 4 => "Четверг", 5 => "Пятница" }

  (1..5).each do |wd|
    p = Preset.create!(user: user, name: names[wd], weekday: wd)

    # Tempo элемент
    PresetItem.create!(
      preset: p,
      system: "tempo",
      issue_key: "APP-123",
      description: "Daily planning",
      minutes_spent: 30,
      tempo_work_kind: "planning",
      tempo_cs_action: "consulting",
      tempo_cs_is: "core"
    )

    # Yaga элемент
    PresetItem.create!(
      preset: p,
      system: "yaga",
      issue_key: "LZ-1547",
      description: "Standup",
      minutes_spent: 20,
      yaga_workspace: "Main",
      yaga_work_kind: "meeting"
    )
  end

  puts "Created weekday presets for #{user.email}"
else
  puts "Presets already exist for #{user.email} — skipping"
end

# 3) (Необязательно) Сообщение по окончанию
puts "Seeds finished."
