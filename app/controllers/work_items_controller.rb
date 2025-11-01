class WorkItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @work_item = current_user.work_items.new(work_item_params)

    if @work_item.save
      # после сохранения вернёмся на текущую неделю
      redirect_to root_path(week_start: params[:week_start], weekend: params[:weekend]), notice: "Карточка создана"
    else
      redirect_to root_path(week_start: params[:week_start], weekend: params[:weekend]), alert: @work_item.errors.full_messages.to_sentence
    end
  end

  private

  def work_item_params
    params.require(:work_item).permit(:date, :minutes_spent, :project_key, :issue_key, :description)
  end
end
