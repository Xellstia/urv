class WorkItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work_item, only: [:edit, :update, :destroy, :show]

  def new
    @date     = params[:date]&.to_date || Date.current
    @system   = (params[:system].presence || "tempo").to_s
    @frame_id = params[:frame_id]
    @work_item = current_user.work_items.new(date: @date, system: @system)
    apply_tempo_defaults(@work_item) if @system == "tempo"
    apply_yaga_defaults(@work_item)  if @system == "yaga"
    render :new
  end

  def create
    @work_item = current_user.work_items.new(work_item_params)

    if @work_item.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: streams_after_create(@work_item) }
        format.html do
          week_start = @work_item.date.beginning_of_week(:monday)
          redirect_to root_path(week_start:, weekend: params[:weekend]), notice: "Карточка создана"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html do
          week_start = (params[:week_start]&.to_date || Date.current.beginning_of_week(:monday))
          redirect_to root_path(week_start:, weekend: params[:weekend]), alert: @work_item.errors.full_messages.to_sentence
        end
      end
    end
  end

  def edit
    render :edit
  end

  def update
    old_date = @work_item.date

    if @work_item.update(work_item_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: streams_after_update(@work_item, old_date) }
        format.html do
          week_start = @work_item.date.beginning_of_week(:monday)
          redirect_to root_path(week_start:, weekend: params[:weekend]), notice: "Изменения сохранены"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    date = @work_item.date
    @work_item.destroy

    respond_to do |format|
      format.turbo_stream do
        streams = []

        # 1) Обновить список дня (innerHTML, id контейнера сохраняется)
        items = current_user.work_items.where(date: date).order(:created_at)
        streams << turbo_stream.update(
          view_context.day_list_dom_id(date),
          partial: "timesheets/day_list",
          locals: { items: items }
        )

        # 2) Обновить шапку дня
        day_total = WorkSummaryService.day_total(user: current_user, date: date)
        streams << turbo_stream.update(
          view_context.day_header_dom_id(date),
          partial: "timesheets/day_header",
          locals: { day: date, total_min: day_total }
        )

        # 3) Обновить сводку недели
        week_start = date.beginning_of_week(:monday)
        week_total = WorkSummaryService.week_total(user: current_user, week_start: week_start)
        streams << turbo_stream.update(
          view_context.week_header_dom_id,
          partial: "timesheets/week_header",
          locals: { total_min: week_total }
        )

        render turbo_stream: streams
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

  def apply_tempo_defaults(record)
    Tempo::DefaultApplier.new(user: current_user).apply(record)
  end

  # ===== Turbo Stream Helpers =====

  # После создания: перерисовываем список дня, шапку дня/недели и очищаем фрейм формы
  def streams_after_create(item)
    date = item.date
    streams = []

    # 1) Список дня
    items = current_user.work_items.where(date: date).order(:created_at)
    streams << turbo_stream.update(
      view_context.day_list_dom_id(date),
      partial: "timesheets/day_list",
      locals: { items: items }
    )

    # 2) Шапка дня
    day_total = WorkSummaryService.day_total(user: current_user, date: date)
    streams << turbo_stream.update(
      view_context.day_header_dom_id(date),
      partial: "timesheets/day_header",
      locals: { day: date, total_min: day_total }
    )

    # 3) Сводка недели
    week_start = date.beginning_of_week(:monday)
    week_total = WorkSummaryService.week_total(user: current_user, week_start: week_start)
    streams << turbo_stream.update(
      view_context.week_header_dom_id,
      partial: "timesheets/week_header",
      locals: { total_min: week_total }
    )

    # 4) Закрыть форму (очистить фрейм)
    frame_id = params[:frame_id]
    streams << turbo_stream.update(frame_id, "") if frame_id.present?

    streams
  end

  # После обновления: если дата изменилась — перерисовать оба дня; иначе — текущий
  def streams_after_update(item, old_date)
    new_date = item.date
    streams  = []

    if old_date != new_date
      # Старый день
      old_items = current_user.work_items.where(date: old_date).order(:created_at)
      streams << turbo_stream.update(
        view_context.day_list_dom_id(old_date),
        partial: "timesheets/day_list",
        locals: { items: old_items }
      )
      old_total = WorkSummaryService.day_total(user: current_user, date: old_date)
      streams << turbo_stream.update(
        view_context.day_header_dom_id(old_date),
        partial: "timesheets/day_header",
        locals: { day: old_date, total_min: old_total }
      )

      # Новый день
      new_items = current_user.work_items.where(date: new_date).order(:created_at)
      streams << turbo_stream.update(
        view_context.day_list_dom_id(new_date),
        partial: "timesheets/day_list",
        locals: { items: new_items }
      )
      new_total = WorkSummaryService.day_total(user: current_user, date: new_date)
      streams << turbo_stream.update(
        view_context.day_header_dom_id(new_date),
        partial: "timesheets/day_header",
        locals: { day: new_date, total_min: new_total }
      )
    else
      # Дата та же — перерисовать текущий день
      same_items = current_user.work_items.where(date: new_date).order(:created_at)
      streams << turbo_stream.update(
        view_context.day_list_dom_id(new_date),
        partial: "timesheets/day_list",
        locals: { items: same_items }
      )
      day_total = WorkSummaryService.day_total(user: current_user, date: new_date)
      streams << turbo_stream.update(
        view_context.day_header_dom_id(new_date),
        partial: "timesheets/day_header",
        locals: { day: new_date, total_min: day_total }
      )
    end

    # Сводка недели
    week_start = new_date.beginning_of_week(:monday)
    week_total = WorkSummaryService.week_total(user: current_user, week_start: week_start)
    streams << turbo_stream.update(
      view_context.week_header_dom_id,
      partial: "timesheets/week_header",
      locals: { total_min: week_total }
    )

    streams
  end

  def apply_tempo_defaults(record)
    Tempo::DefaultApplier.new(user: current_user).apply(record)
  end

  def apply_yaga_defaults(record)
    Yaga::DefaultApplier.new(user: current_user).apply(record)
  end
end
