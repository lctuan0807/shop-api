class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :content, :options, :sender_id, :sender_type, :receiver_id, :created_at
end
