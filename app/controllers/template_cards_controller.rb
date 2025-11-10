class TemplateCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category
  before_action :set_card, only: [:edit, :update, :destroy]

  def new
    @frame_id = params[:frame_id]
    @system = (params[:system].presence || "tempo").to_s
    @card   = @category.template_cards.new(system: @system, minutes_spent: 30)
    apply_tempo_defaults(@card) if @system == "tempo"
    apply_yaga_defaults(@card)  if @system == "yaga"
    respond_to do |format|
      format.html do
        if turbo_frame_request?
          render :new, layout: false
        else
          redirect_to template_categories_path
        end
      end
    end
  end

  def create
    @card = @category.template_cards.new(card_params)
    frame_id = params[:frame_id].presence || params.dig(:template_card, :frame_id)

    if @card.save
      respond_to do |format|
        format.turbo_stream do
          streams = []
          # 1) добавить карточку в список категории
          list_id = "template_category_list_#{@category.id}"
          streams << turbo_stream.append(list_id,
                                         partial: "template_cards/card",
                                         locals: { card: @card })
          # 2) очистить/закрыть форму (frame)
          streams << turbo_stream.update(frame_id, "") if frame_id.present?
          render turbo_stream: streams
        end
        format.html { redirect_to template_categories_path, notice: "Карточка добавлена" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @frame_id = params[:frame_id]
    respond_to do |format|
      format.html do
        if turbo_frame_request? || @frame_id.present?
          render :edit, layout: false
        else
          redirect_to template_categories_path
        end
      end
    end
  end

  def update
    frame_id = params[:frame_id].presence || params.dig(:template_card, :frame_id)
    if @card.update(card_params)
      respond_to do |format|
        format.turbo_stream do
          streams = []
          streams << turbo_stream.replace(dom_id(@card),
                                          partial: "template_cards/card",
                                          locals: { card: @card })
          streams << turbo_stream.update(frame_id, "") if frame_id.present?
          render turbo_stream: streams
        end
        format.html { redirect_to template_categories_path, notice: "Карточка обновлена" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    id = dom_id(@card)
    @card.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(id) }
      format.html { redirect_to template_categories_path, notice: "Карточка удалена" }
    end
  end

  private

  def dom_id(record)
    ActionView::RecordIdentifier.dom_id(record)
  end

  def set_category
    @category = current_user.template_categories.find(params[:template_category_id])
  end

  def set_card
    @card = @category.template_cards.find(params[:id])
  end

  def card_params
    params.require(:template_card).permit(
      :system, :issue_key, :description, :minutes_spent,
      :tempo_work_kind, :tempo_cs_action, :tempo_cs_is,
      :yaga_workspace, :yaga_work_kind
    )
  end

  def apply_tempo_defaults(record)
    Tempo::DefaultApplier.new(user: current_user).apply(record)
  end

  def apply_yaga_defaults(record)
    Yaga::DefaultApplier.new(user: current_user).apply(record)
  end
end
