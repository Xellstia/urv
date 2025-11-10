module TempoHelper
  def tempo_attribute_options(category, user = current_user)
    scope = TempoWorkAttribute.where(category: category.to_s).order(:name)
    if user.present?
      pref = user.tempo_attribute_preferences.find_by(category: category.to_s)
      scope = scope.where(external_id: pref.visible_ids) if pref&.visible_ids.present?
    end
    scope
  end
end
