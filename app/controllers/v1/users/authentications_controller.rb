module V1
  class Users::AuthenticationsController < ApplicationController
    skip_before_action :authenticate_request

    def create
      user = User.find_by(email: params.dig(:user, :email))

      if user&.authenticate(params.dig(:user, :password))
        render json: { message: "User logged in", token: user.auth_token }, status: :ok
      else
        render json: { errors: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      Current.user&.regenerate_auth_token
      render json: {}, status: :no_content
    end
  end
end
