class WorkSummaryService
  def initialize(user:, week_start:)
    @user = user
    @week_start = week_start.beginning_of_week(:monday)
  end

  def call
    range = @week_start..(@week_start + 6)
    items = @user.work_items.where(date: range)

    {
      by_day: items.group(:date).sum(:minutes_spent), # {date => minutes}
      total_minutes: items.sum(:minutes_spent)
    }
  end

  # Удобные одноточечные методы для апдейтов
  def self.day_total(user:, date:)
    user.work_items.where(date: date).sum(:minutes_spent)
  end

  def self.week_total(user:, week_start:)
    range = week_start.beginning_of_week(:monday)..(week_start.beginning_of_week(:monday) + 6)
    user.work_items.where(date: range).sum(:minutes_spent)
  end
end
