class ErrorNotifier
  def self.notify(error)
    DiscordWebhookService.notify(
      <<~MSG
        🚨 Rails Error

        Error Code: #{error.code}
        Error Message: #{error.message}

        #{error.backtrace.first(5).join("\n")}

        MSG
    )
  end
end
