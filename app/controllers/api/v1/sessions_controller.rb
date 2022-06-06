class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create, :verify_activation_token, :change_password]
  before_action :authenticate_user!, only: [:verify_activation_token, :change_password]
  DISABLED_LOGIN_MESSAGE='Your account is disabled'.freeze

  def create
    if params[:phone].blank? || params[:password].blank?
      return
    end

    user = User.find_by(phone: params[:phone].to_s.downcase)
    if user&.authenticate(params[:password]) && (token = user.generate_token)
      if user.disabled?
        render_error(DISABLED_LOGIN_MESSAGE, :bad_request) 
        return
      end

      render json: { token: token }, status: :ok
    else
      render_error 'Wrong phone or password', :unauthorized
    end
  end

  def verify_activation_token
    email = params['email']
    token = params['token']

    decoded = nil
    begin
      decoded = JsonWebToken.new.decode token
    rescue
      render_error "Invalid activation link"
    end

    uid = decoded['sub']
    iat = decoded['iat']
    expired_at = decoded['expired_at']

    return render_error "Invalid token" unless uid == current_user.id
    return render_error "Token expired" if Time.now.to_i > expired_at

    secure = SecurityGateway.find_by(code: 'account_setup')
    if secure && (user_secure = UserSecurityGateway.find_by(status: 'doing', security_gateway_id: secure.id))
      user_secure.status = 'done' if user_secure.current_step == (secure.steps.length - 1)
      user_secure.save
    end

    user = current_user
    user.status = User::Status::ACTIVE
    user.save

    return render json: {
      message: "Ok"
    }, status: :ok
  end

  def change_password
    current_password = params["current_password"]
    new_password = params["new_password"]
    confirm_new_password = params["confirm_new_password"]

    return render_error "Current password is invalid" unless current_user.authenticate(current_password)
    return render_error "Invalid password" unless new_password.length > 5
    return render_error "New password doesn't match with confirm new password" unless (new_password == confirm_new_password)

    current_user.update(password: new_password)

    return render json: {
      message: "Ok"
    }, status: :ok
  end
end
