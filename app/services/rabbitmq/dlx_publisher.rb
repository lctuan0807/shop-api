module Rabbitmq
  class DlxPublisher
    class << self
      NOTI_EXCHANGE = "notification.exchange"
      NOTI_QUEUE_PROCESS = "notifications.queue.process"
      NOTI_ROUTING_KEY = "notification.routing_key"
      DEAD_LETTER_EXCHANGE = "notification.dlx.exchange"
      DEAD_LETTER_ROUTING_KEY = "notification.routing_key.dlx"

      def publish
        # create exchange
        main_exchange = $rabbitmq_channel.direct(NOTI_EXCHANGE, durable: true)

        # create queue
        notification_queue = $rabbitmq_channel.queue(
          NOTI_QUEUE_PROCESS,
          durable: true, # true: survive broker restart
          exclusive: false, # false: allow other connections to access the queue
          arguments: {
            "x-dead-letter-exchange" => DEAD_LETTER_EXCHANGE, # exchange to send messages to when they are dead lettered
            "x-dead-letter-routing-key" => DEAD_LETTER_ROUTING_KEY # routing key to use when sending dead lettered messages
          }
        )

        # bind queue
        notification_queue.bind(main_exchange, routing_key: NOTI_ROUTING_KEY)

        # send message
        main_exchange.publish("test message", routing_key: NOTI_ROUTING_KEY)
      end
    end
  end
end
