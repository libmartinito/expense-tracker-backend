class ApplicationController < ActionController::API
  include ErrorHandler

  before_action :authenticate_request

  private

  def authenticate_request
    auth_token = request.headers["Authorization"]
    user = User.find_by(auth_token: auth_token)
    return Current.user = user if user

    raise CustomError.new(:unauthorized, "401", "Unauthorized", "Not authenticated")
  end
end
