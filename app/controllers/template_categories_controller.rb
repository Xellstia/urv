class TemplateCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy, :toggle_collapse]

  def index
    @categories = current_user.template_categories.includes(:template_cards).ordered
    @new_category = current_user.template_categories.new
  end

  def create
    @category = current_user.template_categories.new(category_params)
    if @category.save
      redirect_to template_categories_path, notice: "Категория добавлена"
    else
      @categories = current_user.template_categories.includes(:template_cards).ordered
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to template_categories_path, notice: "Категория обновлена"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_collapse
    @category.update!(collapsed: !@category.collapsed)
    redirect_to template_categories_path
  end

  def destroy
    name = @category.name
    @category.destroy
    redirect_to template_categories_path, notice: "Категория «#{name}» удалена"
  end

  private

  def set_category
    @category = current_user.template_categories.find(params[:id])
  end

  def category_params
    params.require(:template_category).permit(:name, :collapsed)
  end
end
