class TimesheetsController < ApplicationController
  before_action :authenticate_user!

    def index
      @week_start = (params[:week_start]&.to_date || Date.current.beginning_of_week(:monday))
      @days       = (@week_start..(@week_start + 6)).to_a
      @show_weekend = ActiveModel::Type::Boolean.new.cast(params[:weekend])

      # Выбираем карточки за неделю текущего пользователя
      @items_by_day = current_user
        .work_items
        .where(date: @days)
        .order(:date, :created_at)
        .group_by(&:date)

      # Предрасчитываем суммы на день (для прогресс-бара)
      @totals_by_day = {}
      @days.each do |d|
        @totals_by_day[d] = (@items_by_day[d] || []).sum(&:minutes_spent)
      end
    end

    def prefill
      date = params[:date]&.to_date
      unless date
        redirect_to root_path, alert: "Неверная дата" and return
      end

      ::PresetApplier.new(user: current_user).call(date: date)

      redirect_to root_path(
        week_start: date.beginning_of_week(:monday),
        weekend: params[:weekend]
      ), notice: "Предзаполнено для #{date.strftime('%a, %d %b')}"
    end

end
