class Api::V1::ApiController < ApplicationController
  include JSONAPI::ActsAsResourceController
  skip_before_action :verify_authenticity_token
  
  before_action :authenticate_user!

  def context
    unless @context
      @context = {
        user: current_user,
        current_token: current_token,
        base_url: request.base_url
      }
    end

    @context
  end
end