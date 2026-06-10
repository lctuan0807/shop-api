if Defined?(Bunny)
  # Resolves automatically to amqp://your_user:pass@rabbitmq:5672 in production
  rabbitmq_url = ENV.fetch("RABBITMQ_URL") { "amqp://guest:guest@localhost:5672" }
  $rabbitmq_connection = Bunny.new(rabbitmq_url)
  $rabbitmq_connection.start

  # Setup a channel for publishing
  $rabbitmq_channel = $rabbitmq_connection.create_channel
end
