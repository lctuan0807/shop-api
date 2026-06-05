module Rabbitmq
  class Publisher
    def self.publish(queue, message)
      $rabbitmq_channel.quorum_queue(queue).publish(message)
    end
  end
end
