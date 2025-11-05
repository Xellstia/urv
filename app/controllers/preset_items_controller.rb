class PresetItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preset

  def new
    @frame_id    = params[:frame_id]
    @preset_item = @preset.preset_items.new(
      system: (params[:system].presence || "tempo"),
      minutes_spent: 30
    )
    render :new
  end

  def create
    @preset_item = @preset.preset_items.new(preset_item_params)
    frame_id = params[:frame_id].presence || params.dig(:preset_item, :frame_id)

    if @preset_item.save
      respond_to do |format|
        format.turbo_stream do
          streams = []
          # 1) добавить карточку в колонку
          streams << turbo_stream.append(day_list_dom_id(@preset.weekday),
                                         partial: "preset_items/card",
                                         locals: { pi: @preset_item })
          # 2) очистить/закрыть форму (frame)
          streams << turbo_stream.update(frame_id, "") if frame_id.present?
          render turbo_stream: streams
        end
        format.html { redirect_to presets_path, notice: "Строка добавлена" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @preset_item = @preset.preset_items.find(params[:id])
    render :edit
  end

  def update
    @preset_item = @preset.preset_items.find(params[:id])
    if @preset_item.update(preset_item_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id(@preset_item),
                                                    partial: "preset_items/card",
                                                    locals: { pi: @preset_item })
        end
        format.html { redirect_to presets_path, notice: "Строка обновлена" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @preset_item = @preset.preset_items.find(params[:id])
    id = dom_id(@preset_item)
    @preset_item.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(id) }
      format.html { redirect_to presets_path, notice: "Строка удалена" }
    end
  end

  private

  def set_preset
    @preset = Preset.where(user_id: current_user.id).find(params[:preset_id])
  end

  def preset_item_params
    params.require(:preset_item).permit(
      :system, :issue_key, :description, :minutes_spent,
      # Tempo-специфичные
      :tempo_work_kind, :tempo_cs_action, :tempo_cs_is,
      # Яга-специфичные
      :yaga_workspace, :yaga_work_kind
    )
  end

  def dom_id(record)
    ActionView::RecordIdentifier.dom_id(record)
  end

  def day_list_dom_id(weekday)
    "preset_day_list_#{weekday}"
  end
end
