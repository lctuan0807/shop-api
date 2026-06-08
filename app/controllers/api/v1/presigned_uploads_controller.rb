
module Api
  module V1
    class PresignedUploadsController < ApplicationController
      skip_before_action :authenticate!

      def create
        key = "products/#{SecureRandom.uuid}.jpg"

        url = S3::PresignedUrlService.new(key: key).call

        render_success(
          "Upload URL generated",
          {
            upload_url: url,
            key: key
          }
        )
      end
    end
  end
end
