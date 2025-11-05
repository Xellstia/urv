module DomHelper
  # turbo-frame id для дневной формы: например "day-20251027-form"
  def day_frame_id(date)
    "day-#{date.strftime('%Y%m%d')}-form"
  end
end
