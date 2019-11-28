class Api::V1::BaseApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  def current_user
    @current_user ||= User.first
  end
end
