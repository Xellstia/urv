class PingJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "[PingJob] hello from sidekiq #{Time.current}"
  end
end