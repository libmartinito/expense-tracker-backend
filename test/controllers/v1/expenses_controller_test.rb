require "test_helper"

class V1::ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should create expense with valid params" do
    user = users(:one)

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    assert_response :success

    post v1_expenses_path, headers: {
      "Authorization": user.auth_token
    }, params: {
      expense: {
        item: "croissant",
        amount_in_cents: 12500,
        currency: "PHP",
        purchased_at: Time.now
      }
    }

    assert_response :created
    assert_equal 1, Expense.count
  end

  test "should not create expense with invalid params" do
    user = users(:one)

    post v1_login_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }

    assert_response :success

    post v1_expenses_path, headers: {
      "Authorization": user.auth_token
    }, params: {
      expense: {
        amount_in_cents: 12500,
        currency: "PHP",
        purchased_at: Time.now
      }
    }

    assert_response :unprocessable_entity
    assert_equal 0, Expense.count
  end

  test "should not create expense if not authenticated" do
    post v1_expenses_path, params: {
      expense: {
        item: "croissant",
        amount_in_cents: 12500,
        currency: "PHP",
        purchased_at: Time.now
      }
    }

    assert_response :unauthorized
    assert_equal 0, Expense.count
  end
end
