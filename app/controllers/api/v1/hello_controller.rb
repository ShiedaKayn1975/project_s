class Api::V1::HelloController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def hello
    result = {
      user: "test"
    }

    render json: result
  end
end
