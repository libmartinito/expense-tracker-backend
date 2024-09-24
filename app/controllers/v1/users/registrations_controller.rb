class V1::Users::RegistrationsController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.new(user_params)

    if user.save
      render json: UserSerializer.new(user).serializable_hash.to_json, status: :created
    else
      render json: { message: "User not created", errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
