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

      # Generate a signed URL for the file with CloudFront
      CloudfrontSignerService.generate_url(key)
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
  end
end
