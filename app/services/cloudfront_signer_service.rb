class CloudfrontSignerService
  def self.generate_url(blob_key, expires_in: 10.minutes)
    unsigned_url = ENV['CLOUDFRONT_DOMAIN'] + "/#{blob_key}"
    
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: ENV['CLOUDFRONT_KEY_PAIR_ID'],
      private_key: ENV['CLOUDFRONT_PRIVATE_KEY']
    )
    
    signer.signed_url(
      unsigned_url,
      expires: Time.current.to_i + expires_in.to_i
    )
  end
end
