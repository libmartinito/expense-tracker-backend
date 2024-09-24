class V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    if Current.user == user
      render json: UserSerializer.new(user).serializable_hash, status: :ok
    else
      raise CustomError.new(:unauthorized, "401", "Unauthorized", "Not authorized")
    end
  end
end
