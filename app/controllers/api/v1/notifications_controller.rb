module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        notifications = Notification.by_user(user_id)
        notifications = notifications.by_kind(kind) if kind

        render_success(
          "Notifications retrieved successfully",
          { notifications: serialize_collection(notifications, serializer: NotificationSerializer) }
        )
      end

      private

      def kind
        params[:kind] == "all" ? nil : params[:kind]
      end

      def user_id
        params[:user_id]
      end
    end
  end
end
