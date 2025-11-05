class WorkItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work_item, only: [:edit, :update, :destroy]

  def new
    @date     = params[:date]&.to_date || Date.current
    @system   = (params[:system].presence || "tempo").to_s
    @frame_id = params[:frame_id]
    @work_item = current_user.work_items.new(date: @date, system: @system)

    render :new
  end

  def create
    @work_item = current_user.work_items.new(work_item_params)

    if @work_item.save
      week_start = @work_item.date.beginning_of_week(:monday)
      redirect_to root_path(week_start:, weekend: params[:weekend]), notice: "Карточка создана"
    else
      week_start = (params[:week_start]&.to_date || Date.current.beginning_of_week(:monday))
      redirect_to root_path(week_start:, weekend: params[:weekend]), alert: @work_item.errors.full_messages.to_sentence
    end
  end

  def edit
    # Редактируем карточку прямо на её месте:
    # оборачиваем в turbo-frame с id = dom_id(@work_item)
    render :edit
  end

  def update
    if @work_item.update(work_item_params)
      week_start = @work_item.date.beginning_of_week(:monday)
      redirect_to root_path(week_start:, weekend: params[:weekend]), notice: "Изменения сохранены"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work_item = current_user.work_items.find(params[:id])
    date = @work_item.date
    dom = view_context.dom_id(@work_item)

    @work_item.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom)
      end
      format.html do
        redirect_to root_path(
          week_start: date.beginning_of_week(:monday),
          weekend: params[:weekend]
        ), notice: "Карточка удалена"
      end
    end
  end

  def show
  @work_item = current_user.work_items.find(params[:id])
  render :show
  end

  private

  def set_work_item
    @work_item = current_user.work_items.find(params[:id])
  end

  def work_item_params
    params.require(:work_item).permit(
      :date, :minutes_spent, :issue_key, :description, :title, :system,
      :tempo_work_kind, :tempo_cs_action, :tempo_cs_is,
      :yaga_workspace, :yaga_work_kind
    )
  end
end
