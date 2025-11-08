# app/helpers/timesheets_helper.rb
module TimesheetsHelper
  WORKDAY_MINUTES = 8 * 60

  # 245 -> "4h 05m"
  def format_minutes_hm(minutes)
    m = minutes.to_i
    h = m / 60
    mm = m % 60
    "#{h}h #{format('%02d', mm)}m"
  end

  # 245 -> 51.04 (clamped 0..100)
  def day_progress_pct(minutes)
    pct = (minutes.to_f / WORKDAY_MINUTES.to_f) * 100.0
    [[pct, 0.0].max, 100.0].min.round(2)
  end

  # Красивая дата заголовка: "Mon, 03 Nov"
  def day_title(date)
    date.strftime("%a, %d %b")
  end
end

