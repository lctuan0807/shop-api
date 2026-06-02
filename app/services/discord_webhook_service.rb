require "net/http"
require "json"

class DiscordWebhookService
  include HTTParty

  WEBHOOK_URL = ENV.fetch("DISCORD_WEBHOOK_URL")

  # def self.notify(message)
  #   uri = URI(WEBHOOK_URL)

  #   Net::HTTP.post(
  #     uri,
  #     { content: message }.to_json,
  #     "Content-Type" => "application/json"
  #   )
  # rescue => e
  #   Rails.logger.error("Discord notification failed: #{e.message}")
  # end

  def self.notify(message)
    response = post(
      WEBHOOK_URL,
      headers: {
        "Content-Type" => "application/json"
      },
      body: {
        content: message
      }.to_json
    )

    raise "Discord webhook failed: #{response.code}" unless response.success?

    response
  end
end
