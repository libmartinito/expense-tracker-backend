require "test_helper"

class V1::Users::AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should authenticate user with valid credentials" do
    user = users(:one)

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    assert_response :success
    assert_equal user.auth_token, JSON.parse(response.body).dig("data", "attributes", "token")
  end

  test "should not authenticate user with invalid email" do
    post v1_login_path, params: {
      user: {
        email: "wrong@mail.com",
        password: "password"
      }
    }

    assert_response :unauthorized
  end

  test "should not authenticate user with invalid password" do
    user = users(:one)

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "wrong-password"
      }
    }

    assert_response :unauthorized
  end

  test "should regenerate new token for user when logged out" do
    user = users(:one)
    old_token = user.auth_token

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    assert_response :success

    post v1_logout_path, headers: {
      "Authorization": old_token
    }

    assert_response :no_content
    assert_not_equal old_token, user.reload.auth_token
  end
end
