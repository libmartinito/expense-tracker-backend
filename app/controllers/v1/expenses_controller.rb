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
    page_size = (params.dig(:page, :size) || 10).to_i
    page_cursor = (params.dig(:page, :cursor) || 0).to_i

    expenses = Expense.where("id > ?", page_cursor).limit(page_size)
    total = Expense.count

    last_cursor = total > 0 ? [ (total / page_size) * page_size, total ].min : nil

    first_link = "http://localhost:3000/v1/expenses?page[cursor]=0&page[size]=#{page_size}"
    last_link = last_cursor ? "http://localhost:3000/v1/expenses?page[cursor]=#{last_cursor}&page[size]=#{page_size}" : nil
    prev_link = expenses.first.id != 1 ? "http://localhost:3000/v1/expenses?page[cursor]=#{expenses.first.id - 1}&page[size]=#{page_size}" : nil
    next_link = expenses.last.id != total ? "http://localhost:3000/v1/expenses?page[cursor]=#{expenses.last.id}&page[size]=#{page_size}" : nil

    render json: ExpenseSerializer.new(expenses, {
      links: {
        first: first_link,
        last: last_link,
        prev: prev_link,
        next: next_link
      }
    }).serializable_hash, status: :ok
  end

  private

  def expense_params
    params.require(:expense).permit(:item, :amount_in_cents, :currency, :purchased_at)
  end
end
