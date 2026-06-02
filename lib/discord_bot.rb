require "discordrb"

class DiscordBot
  def self.start
    bot = Discordrb::Bot.new(
      token: ENV["DISCORD_BOT_TOKEN"]
    )

    bot.message(content: "!ping") do |event|
      event.respond "Pong!"
    end

    bot.run
  end
end
