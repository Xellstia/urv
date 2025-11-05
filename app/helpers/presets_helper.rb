module PresetsHelper
  # id turbo-frame для формы в столбце пресетов
  def preset_day_frame_id(weekday)
    "preset_day_frame_#{weekday}"
  end

  # контейнер для карточек (ul/div) — чтобы удобно append-ить turbo_stream’ом
  def preset_day_list_id(weekday)
    "preset_day_list_#{weekday}"
  end

  # Красивые названия дней
  def weekday_name(wd)
    {1=>"Понедельник",2=>"Вторник",3=>"Среда",4=>"Четверг",5=>"Пятница",6=>"Суббота",7=>"Воскресенье"}[wd]
  end
end
