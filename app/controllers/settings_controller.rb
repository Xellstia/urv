class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @tempo_attributes = TempoWorkAttribute.order(:category, :name).group_by(&:category)
    @visibility = current_user.tempo_attribute_preferences.index_by(&:category)
  end

  def update
    case params[:section]
    when "credentials"
      update_credentials
    when "tempo_defaults"
      update_tempo_defaults
    when "yaga_defaults"
      update_yaga_defaults
    when "tempo_visibility"
      update_tempo_visibility
    else
      redirect_to settings_path, alert: "Неизвестный раздел"
    end
  end

  private

  def update_credentials
    attrs = credential_params.to_h
    %w[tempo yaga otrs].each do |prefix|
      password_key = "#{prefix}_password"
      attrs.delete(password_key) if attrs[password_key].blank?
    end

    if current_user.update(attrs)
      redirect_to settings_path, notice: "Учётные данные обновлены"
    else
      flash.now[:alert] = "Не удалось сохранить"
      render :show, status: :unprocessable_entity
    end
  end

  def update_tempo_defaults
    defaults = current_user.tempo_defaults.merge(tempo_default_params.compact_blank)
    if current_user.update(tempo_defaults: defaults)
      redirect_to settings_path, notice: "Значения по умолчанию сохранены"
    else
      flash.now[:alert] = "Не удалось сохранить"
      render :show, status: :unprocessable_entity
    end
  end

  def update_yaga_defaults
    defaults = current_user.yaga_defaults.merge(yaga_default_params.compact_blank)
    if current_user.update(yaga_defaults: defaults)
      redirect_to settings_path, notice: "Значения по умолчанию сохранены"
    else
      flash.now[:alert] = "Не удалось сохранить"
      render :show, status: :unprocessable_entity
    end
  end

  def update_tempo_visibility
    visibility_params.each do |category, ids|
      pref = current_user.tempo_attribute_preferences.find_or_initialize_by(category: category)
      cleaned = ids.reject(&:blank?).map(&:to_i)
      pref.visible_ids = cleaned.presence
      pref.save!
    end
    redirect_to settings_path, notice: "Видимость обновлена"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to settings_path, alert: e.message
  end

  def credential_params
    params.require(:user).permit(
      :tempo_login, :tempo_password,
      :yaga_login, :yaga_password,
      :otrs_login, :otrs_password
    )
  end

  def tempo_default_params
    params.require(:tempo_defaults).permit(:issue_key, :work_kind_id, :cs_action_id, :cs_is_id)
  end

  def yaga_default_params
    params.require(:yaga_defaults).permit(:issue_key, :workspace, :work_kind)
  end

  def visibility_params
    permitted = params.fetch(:visibility, {}).permit(work_kind: [], cs_action: [], cs_is: [])
    permitted.to_h
  end
end
