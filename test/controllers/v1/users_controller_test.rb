require "test_helper"

class V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should show user" do
    user = users(:one)

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    assert_response :success

    get v1_user_path(user.id), headers: {
      "Authorization": user.auth_token
    }

    assert_response :success
  end

  test "should not return user if not authenticated" do
    get v1_user_path(1)

    assert_response :unauthorized
  end
end
