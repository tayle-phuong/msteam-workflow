class KeepMeAliveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Faraday.get("https://msteam-workflow.onrender.com/up?from_cron")
  end
end
