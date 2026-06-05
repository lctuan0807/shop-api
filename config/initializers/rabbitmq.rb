$rabbitmq_connection = Bunny.new(ENV['RABBITMQ_URL'])
$rabbitmq_connection.start

# Setup a channel for publishing
$rabbitmq_channel = $rabbitmq_connection.create_channel
