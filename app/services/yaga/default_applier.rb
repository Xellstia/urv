module Yaga
  class DefaultApplier
    def initialize(user:)
      @user = user
    end

    def apply(record)
      return record unless @user&.yaga_defaults.present?

      defaults = @user.yaga_defaults
      record.issue_key ||= defaults["issue_key"] if record.respond_to?(:issue_key)
      record.yaga_workspace ||= defaults["workspace"] if record.respond_to?(:yaga_workspace)
      record.yaga_work_kind ||= defaults["work_kind"] if record.respond_to?(:yaga_work_kind)
      record
    end
  end
end
