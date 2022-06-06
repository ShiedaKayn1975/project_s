class Api::V1::AccountsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create]

  INITIAL_STEP = 1

  def create
    @account = Account.new(registration_params)
    @account.status = User::Status::ACTIVE
    @account.admin = false
        
    if @account.save
      token = @account.generate_token      
      @account.generate_code
      
      render json: {
        account: @account.as_json(except: [
          :id, :password_digest
        ]),
        token: token
      }, status: :ok
    else
      render_error @account.errors.full_messages
    end
  end

  private

  def registration_params
    params.permit(:name, :phone, :password)
  end
end
