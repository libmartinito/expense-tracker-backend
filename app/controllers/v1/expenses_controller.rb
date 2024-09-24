class V1::ExpensesController < ApplicationController
  def create
    expense = Current.user.expenses.new(expense_params)

    if expense.save
      render json: ExpenseSerializer.new(expense).serializable_hash.to_json, status: :created
    else
      render json: { message: "Expense not created", errors: expense.errors }, status: :unprocessable_entity
    end
  end

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    expenses = Current.user.expenses.page(page).per(per_page)

    render json: ExpenseSerializer.new(expenses, {
      meta: {
        total: expenses.total_pages
      },
      links: {
        first: "http://localhost:3001/expenses?page=1&per_page=#{per_page}",
        last: "http://localhost:3001/expenses?page=#{expenses.total_pages}&per_page=#{per_page}",
        prev: expenses.prev_page ? "http://localhost:3001/expenses?page=#{expenses.prev_page}&per_page=#{per_page}" : nil,
        next: expenses.next_page ? "http://localhost:3001/expenses?page=#{expenses.next_page}&per_page=#{per_page}" : nil
      }
    }).serializable_hash, status: :ok
  end

  private

  def expense_params
    permitted_params = params.require(:expense).permit(:item, :amount, :currency, :purchased_at)
    permitted_params[:amount_in_cents] = (permitted_params[:amount].to_f * 100).to_i
    permitted_params.except(:amount)
  end
end
