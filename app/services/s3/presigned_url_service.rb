module S3
  class PresignedUrlService
    def initialize(key:)
      @key = key
    end

    def call
      Aws::S3::Presigner.new.presigned_url(
        :put_object,
        bucket: ENV["AWS_BUCKET_NAME"],
        key: key,
        expires_in: 3600
      )
    end

    private

    attr_reader :key
  end
end
