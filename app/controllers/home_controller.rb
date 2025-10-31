class HomeController < ApplicationController
  def index
    PingJob.perform_later
  end
end
