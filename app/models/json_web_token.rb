class JsonWebToken
  attr_accessor :algorithm, :secret

  def initialize(algorithm='HS256', secret=ENV['JWT_SECRET'])
    @algorithm = algorithm
    @secret = secret      
  end

  def encode(payload)
    JWT.encode(payload, secret, algorithm)
  end

  def decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, secret, true, { verify_sub: true, verify_iat: true, algorithm: algorithm })[0])
  end
end