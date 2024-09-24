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

  test "should list expenses" do
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

    post v1_expenses_path, headers: {
      "Authorization": user.auth_token
    }, params: {
      expense: {
        item: "cream puff",
        amount_in_cents: 16000,
        currency: "PHP",
        purchased_at: Time.now
      }
    }

    assert_response :created

    get v1_expenses_path, headers: { "Authorization": user.auth_token }

    assert_response :success
    assert_equal 2, JSON.parse(response.body).dig("data").length
  end

  test "should not list expenses if not authenticated" do
    get v1_expenses_path

    assert_response :unauthorized
  end

  test "should destroy expense" do
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

    delete v1_expense_path(JSON.parse(response.body).dig("data", "id")), headers: {
      "Authorization": user.auth_token
    }

    assert_response :no_content
  end

  test "should not destroy expense if not authenticated" do
    delete v1_expense_path(1)

    assert_response :unauthorized
  end
end
