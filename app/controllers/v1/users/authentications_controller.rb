class V1::Users::AuthenticationsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]

  def create
    user = User.find_by(email: params.dig(:user, :email))

    if user&.authenticate(params.dig(:user, :password))
      render json: AuthenticationSerializer.new(user).serializable_hash.to_json, status: :ok
    else
      raise CustomError.new(:unauthorized, "401", "Unauthorized", "Invalid email or password")
    end
  end

  def destroy
    Current.user&.regenerate_auth_token
    render json: {}, status: :no_content
  end
end
