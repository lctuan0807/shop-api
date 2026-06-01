class RedisLock
  LOCK_TTL = 3.seconds
  
  def initialize(key, expires_in: LOCK_TTL)
    @key = key
    @expires_in = expires_in
  end

  def acquire
    redis.set(@key, SecureRandom.uuid, nx: true, ex: LOCK_TTL)
  end

  def release
    redis.del(@key)
  end

  private

  def redis
    Redis.current
  end
end
