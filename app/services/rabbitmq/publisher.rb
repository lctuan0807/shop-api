module Rabbitmq
  class Publisher
    def self.publish(queue, message)
      # $rabbitmq_channel.quorum_queue(queue).publish(message)

      10.times do |i|
        $rabbitmq_channel.quorum_queue(queue).publish("test message #{i}")
      end
    end
  end
end
