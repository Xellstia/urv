module Tempo
  class DefaultApplier
    def initialize(user:)
      @user = user
    end

    def apply(record)
      return record unless @user&.tempo_defaults.present?

      defaults = @user.tempo_defaults
      record.issue_key ||= defaults["issue_key"] if record.respond_to?(:issue_key)
      assign_attribute(record, :tempo_work_kind, defaults["work_kind_id"])
      assign_attribute(record, :tempo_cs_action, defaults["cs_action_id"])
      assign_attribute(record, :tempo_cs_is, defaults["cs_is_id"])

      record
    end

    private

    def assign_attribute(record, attribute, external_id)
      return unless external_id.present?

      tempo_attr = TempoWorkAttribute.find_by(external_id: external_id)
      return unless tempo_attr

      setter = "#{attribute}="
      record.public_send(setter, tempo_attr.value) if record.respond_to?(setter)
    end
  end
end
