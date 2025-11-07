class TemplateCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category
  before_action :set_card, only: [:edit, :update, :destroy]

  def new
    @system = (params[:system].presence || "tempo").to_s
    @card   = @category.template_cards.new(system: @system, minutes_spent: 30)
  end

  def create
    @card = @category.template_cards.new(card_params)
    if @card.save
      redirect_to template_categories_path, notice: "Карточка добавлена"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @card.update(card_params)
      redirect_to template_categories_path, notice: "Карточка обновлена"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy
    redirect_to template_categories_path, notice: "Карточка удалена"
  end

  private

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
end
