module Api
  module V1
    class DirectUploadsController < ApplicationController
      skip_before_action :authenticate!

      def create
        file = upload_params

        key = "products/1111/#{file.original_filename}"

        url = S3::UploadService.new(
          file: file.tempfile,
          key: key
        ).call

        render_success(
          "Upload successful",
          { url: url }
        )
      end

      private

      def upload_params
        params.require(:file)
      end
    end
  end
end
