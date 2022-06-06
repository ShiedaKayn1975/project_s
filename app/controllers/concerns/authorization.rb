module Authorization
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user,
                :current_token
    
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  def authenticate_user!
    if has_authorization?
      if jwt_claims && jwt_claims['uid'] && (user = User.find_by(id: jwt_claims['uid']))
        @current_user = user
        @current_token = token
      else
        render_error "Invalid credentials", :unauthorized
      end
    else
      render_error "No authorization credentials received"
    end
  end

  private

  def authorization_headers
    request.headers['Authorization']
  end

  def has_authorization?
    authorization_headers.present? &&
    authorization_headers.split(' ').first == 'Bearer' &&
    authorization_headers.split(' ').size == 2
  end

  def token
    authorization_headers.split(' ').second
  end

  def jwt_claims
    begin
      JsonWebToken.new.decode(token)
    rescue JWT::ExpiredSignature
      # Handle expired token, e.g. logout user or deny access
      nil
    rescue JWT::InvalidIatError
      # Handle invalid token, e.g. logout user or deny access
      nil
    rescue StandardError
      nil
    end
  end

  def user_not_authorized
    render json: {
      errors: [{
        detail: 'You don\'t have permission to access this resource.'
      }]
    }, status: 403
  end
end