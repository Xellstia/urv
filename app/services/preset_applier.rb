# frozen_string_literal: true

class PresetApplier
  def initialize(user:)
    @user = user
  end

  # date: Date
  def call(date:)
    weekday = date.cwday
    presets = Preset.where(user_id: @user.id, weekday: weekday).includes(:preset_items)
    created = []

    presets.each do |preset|
      preset.preset_items.each do |pi|
        created << @user.work_items.create!(
          date:            date,
          system:          (pi.system.presence || "tempo"),
          issue_key:       pi.issue_key,
          description:     pi.description,
          minutes_spent:   (pi.minutes_spent || 0),
          tempo_work_kind: pi.tempo_work_kind,
          tempo_cs_action: pi.tempo_cs_action,
          tempo_cs_is:     pi.tempo_cs_is,
          yaga_workspace:  pi.yaga_workspace,
          yaga_work_kind:  pi.yaga_work_kind,
          state:           :draft,
          source:          "preset"
        )
      end
    end

    created
  end
end
