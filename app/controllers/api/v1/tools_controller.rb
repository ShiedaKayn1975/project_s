class Api::V1::ToolsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:get_2fa]
  
  def get_2fa
    text = params["text"]
    url = 'https://2fa.live/tok/' + text
    response = RestClient.get url
    response = JSON.load(response.body)

    return render json: response
  end
end