Aws.config.update(
  region: ENV["AWS_REGION"],
  credentials: Aws::Credentials.new(
    ENV["AWS_BUCKET_ACCESS_KEY"],
    ENV["AWS_BUCKET_SECRET_KEY"]
  )
)
