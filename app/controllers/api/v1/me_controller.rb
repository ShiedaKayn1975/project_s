class Api::V1::MeController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def profile
    # security_gateway = SecurityGateway.joins("INNER JOIN user_security_gateways ON user_security_gateways.security_gateway_id = security_gateways.id").
    #   where('user_security_gateways.status = ? AND user_security_gateways.user_id = ?', 'doing', current_user.id).first()

    result = {
      user: current_user.as_json(
        except: [:password_digest]
      )
    }

    render json: result
  end
end
