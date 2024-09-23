require "test_helper"

class V1::Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should create user with valid params" do
    post v1_register_path, params: {
      user: {
        username: "newuser",
        email: "newuser@mail.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    assert_response :created
  end

  test "should not create user with invalid params" do
    post v1_register_path, params: {
      user: {
        username: "newuser",
        email: "newuser@mail.com",
        password: "password",
        password_confirmation: "wrong-password"
      }
    }

    assert_response :unprocessable_entity
  end
end
