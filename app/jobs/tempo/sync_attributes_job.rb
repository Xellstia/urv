module Tempo
  class SyncAttributesJob < ApplicationJob
    queue_as :default

    def perform
      login = ENV["TEMPO_ADMIN_LOGIN"]
      password = ENV["TEMPO_ADMIN_PASSWORD"]

      unless login.present? && password.present?
        Rails.logger.warn("Tempo::SyncAttributesJob skipped: credentials not configured")
        return
      end

      client = Tempo::Client.new(login: login, password: password)
      AttributeSyncService.new(client: client).call
    rescue Tempo::Error => e
      Rails.logger.error("Tempo sync failed: #{e.message}")
      raise
    end
  end
end
