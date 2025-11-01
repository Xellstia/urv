module TimeHelper
  def minutes_to_hhmm(mins)
    mins = mins.to_i
    hours = mins / 60
    minutes = mins % 60
    format("%dh %02dm", hours, minutes)
  end

  # ширина прогресса «из 8 часов» (можно потом сделать на пользователя)
  def day_progress_width(total_min, target_min = 8 * 60)
    pct = (total_min.to_f / target_min) * 100
    [[pct, 0].max, 100].min.round(0).to_s + "%"
  end
end