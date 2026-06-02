namespace :discord do
  task start: :environment do
    DiscordBot.start
  end
end
