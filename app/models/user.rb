class User < ApplicationRecord
  include SecureTokens
  include Actionable

  module Status
    ACTIVE = 'active'
    DISABLED = 'disabled'
  end

  enumerize :status,
  in: Status.constants.map { |const| Status.const_get(const) }, 
  predicates: true

  scope :active, -> { where(status: Status::ACTIVE) }
  scope :disabled, -> { where(status: Status::DISABLED) }
  scope :validating, -> { where(status: Status::VALIDATING)}

  has_secure_password
  has_secure_tokens

  validates_presence_of :phone
  validates_uniqueness_of :phone, case_sensitive: false

  action :send_activation_email do
    label "Send activation email"

    show? do |object, context|
      false
    end

    authorized? do |object, context|
      false
    end

    commitable? do |object, context|
      false
    end
    
    commit do |object, context|
      object.send_activation_email
    end
  end

  action :update_user_status do 
    label "Update user status"

    show? do |object, context|
      false
    end

    authorized? do |object, context|
      context[:actor].admin
    end

    commitable? do |object, context|
      !object.admin
    end
    
    commit do |object, context|
      status = context[:data]["active"] ? Status::ACTIVE : Status::DISABLED
      object.status = status
      object.save
    end
  end
    
  # def self.find_in_cache uid, token

  # end
  def send_activation_email
    token = generate_activation_token
    UserMailer.activation(self, token).deliver_later
  end

  def generate_activation_token
    JsonWebToken.new.encode({
      sub: self.id,
      iat: Time.now.to_i,
      expired_at: 1.hour.from_now.to_i
    })
  end

  def generate_code
    self.code = "NOKIA" + self.id.to_s
    self.save
  end
end
