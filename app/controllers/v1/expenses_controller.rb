class V1::ExpensesController < ApplicationController
  def create
    expense = Current.user.expenses.new(expense_params)

    if expense.save
      render json: ExpenseSerializer.new(expense).serializable_hash.to_json, status: :created
    else
      render json: { message: "Expense not created", errors: expense.errors }, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:item, :amount_in_cents, :currency, :purchased_at)
  end
end
