module Notifications
  class CreateService
    def initialize(sender:, receiver_id:, kind: "product_created", **options)
      @sender = sender
      @receiver_id = receiver_id
      @kind = kind
      @options = options
    end

    def call
      Notification.create!(
        sender_id: sender.id,
        sender_type: sender.class.name,
        receiver_id: receiver_id,
        kind: kind,
        content: build_content,
        options: options
      )
    end

    private

    def build_content
      case kind
      when "product_created"
        "@@@ just created a new product: @@@@"
      when "product_updated"
        "@@@ just updated a product: @@@@"
      when "promotion_created"
        "@@@ just created a new voucher: @@@@"
      end
    end

    attr_reader :sender, :receiver_id, :kind, :options
  end
end
