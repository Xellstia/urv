class PresetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @week_start   = params[:week_start]&.to_date || Date.current.beginning_of_week(:monday)
    @show_weekend = ActiveModel::Type::Boolean.new.cast(params[:weekend])

    ensure_weekday_buckets!

    # какие дни рисуем
    @weekdays = @show_weekend ? (1..7).to_a : (1..5).to_a

    # items по дням
    @items_by_weekday = Preset
      .where(user_id: current_user.id, weekday: @weekdays)
      .includes(:preset_items)
      .order(:weekday, :id)
      .group_by(&:weekday)
  end

  private

  def ensure_weekday_buckets!
    (1..7).each do |wd|
      Preset.find_or_create_by!(user_id: current_user.id, weekday: wd) do |p|
        names = {1=>"Понедельник",2=>"Вторник",3=>"Среда",4=>"Четверг",5=>"Пятница",6=>"Суббота",7=>"Воскресенье"}
        p.name = names[wd]
      end
    end
  end
end
