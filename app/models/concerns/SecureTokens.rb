module SecureTokens
  extend ActiveSupport::Concern

  class_methods do
    def has_secure_tokens(options = {}) ;end
  end

  def generate_token(expire_at = 1.months.from_now)
    token = JsonWebToken.new.encode({
      iat: Time.now.to_i,
      exp: expire_at.to_i,
      phone: self.phone,
      uid: self.id
    })

    token
  end
end