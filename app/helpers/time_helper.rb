module TimeHelper
  # "120" -> "2h 00m"
  def minutes_to_hhmm(min)
    min = min.to_i
    h = min / 60
    m = min % 60
    "#{h}h #{m.to_s.rjust(2, '0')}m"
  end

  # Для прогресс-бара 8 часов
  def day_progress_width(total_min)
    total = total_min.to_i
    max = 8 * 60.0
    pct = [ (total / max * 100).round, 100 ].min
    "#{pct}%"
  end

  # DOM IDs, которые будем обновлять из Turbo Stream
  def day_header_dom_id(date)
    "day_header_#{date.strftime('%Y%m%d')}"
  end

  def day_list_dom_id(date)
    "day_list_#{date.strftime('%Y%m%d')}"
  end

  def week_header_dom_id
    "week_header_total"
  end
end
