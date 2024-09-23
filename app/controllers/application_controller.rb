class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    auth_token = request.headers["Authorization"]
    user = User.find_by(auth_token: auth_token)
    return Current.user = user if user

    render json: { error: "Not Authenticated" }, status: :unauthorized
  end
end
