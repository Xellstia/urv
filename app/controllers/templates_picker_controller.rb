class TemplatesPickerController < ApplicationController
  before_action :authenticate_user!

  # GET /templates_picker?date=YYYY-MM-DD&frame_id=...&week_start=...&weekend=...
  def show
    @date       = params[:date]&.to_date || Date.current
    @frame_id   = params[:frame_id]
    @week_start = params[:week_start]&.to_date || @date.beginning_of_week(:monday)
    @weekend    = params[:weekend]
    @categories = current_user.template_categories.includes(:template_cards).ordered
    render :show
  end

  # POST /templates_picker/add
  # params: card_id, date, week_start, weekend, picker_btn_id, frame_id
  def add
    card = current_user.template_categories.joins(:template_cards)
             .merge(TemplateCard.where(id: params[:card_id])).first
    raise ActiveRecord::RecordNotFound unless card

    # Создаём WorkItem по шаблону
    date = params[:date]&.to_date || Date.current
    wi = current_user.work_items.create!(
      date: date,
      system:          card.template_cards.find(params[:card_id]).system,
      issue_key:       card.template_cards.find(params[:card_id]).issue_key,
      description:     card.template_cards.find(params[:card_id]).description,
      minutes_spent:   card.template_cards.find(params[:card_id]).minutes_spent || 0,
      tempo_work_kind: card.template_cards.find(params[:card_id]).tempo_work_kind,
      tempo_cs_action: card.template_cards.find(params[:card_id]).tempo_cs_action,
      tempo_cs_is:     card.template_cards.find(params[:card_id]).tempo_cs_is,
      yaga_workspace:  card.template_cards.find(params[:card_id]).yaga_workspace,
      yaga_work_kind:  card.template_cards.find(params[:card_id]).yaga_work_kind,
      state: :draft,
      source: "template"
    )

    picker_btn_id = params[:picker_btn_id] # уникальный id кнопки + в пикере

    respond_to do |format|
      format.turbo_stream do
        streams = []
        # 1) Добавить карточку в список дня
        streams << turbo_stream.append(view_context.day_list_dom_id(date),
                   partial: "work_items/card", locals: { item: wi })

        # 2) Обновить шапку дня
        day_total = WorkSummaryService.day_total(user: current_user, date: date)
        streams << turbo_stream.replace(view_context.day_header_dom_id(date),
                   partial: "timesheets/day_header", locals: { day: date, total_min: day_total })

        # 3) Обновить сводку недели
        week_start = params[:week_start]&.to_date || date.beginning_of_week(:monday)
        week_total = WorkSummaryService.week_total(user: current_user, week_start: week_start)
        streams << turbo_stream.replace(view_context.week_header_dom_id,
                   partial: "timesheets/week_header", locals: { total_min: week_total })

        # 4) Заменить кнопку '+' в пикере на '✓'
        if picker_btn_id.present?
          streams << turbo_stream.replace(picker_btn_id,
                     partial: "templates_picker/picked", locals: { })
        end

        render turbo_stream: streams
      end
      format.html { redirect_to root_path(week_start: params[:week_start], weekend: params[:weekend]) }
    end
  end
end
