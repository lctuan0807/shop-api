module S3
  class UploadService
    def initialize(file:, key:)
      @file = file
      @key = key
    end

    def call
      object.put(
        body: file,
        content_type: content_type
      )

      public_url
    end

    private

    attr_reader :file, :key

    def bucket
      @bucket ||= Aws::S3::Resource.new.bucket(
        ENV.fetch("AWS_BUCKET_NAME")
      )
    end

    def object
      bucket.object(key)
    end

    def content_type
      Marcel::MimeType.for(file)
    end

    def public_url
      object.public_url
    end
  end
end
