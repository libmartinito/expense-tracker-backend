class V1::ExpensesController < ApplicationController
  def create
    expense = Current.user.expenses.new(expense_params)

    if expense.save
      render json: ExpenseSerializer.new(expense).serializable_hash.to_json, status: :created
    else
      raise CustomError.new(:unprocessable_entity, "422", "Unprocessable Entity", "Expense not created")
    end
  end

  def destroy
    expense = Current.user.expenses.find(params[:id])

    if expense
      expense.destroy
      render json: {}, status: :no_content
    else
      raise CustomError.new(:not_found, "404", "Not Found", "Expense not found")
    end
  end

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    expenses = Current.user.expenses

    if params[:month].present? && params[:year].present?
      expenses = expenses.where("strftime('%m', purchased_at) = ? and strftime('%Y', purchased_at) = ?", params[:month], params[:year])
    end

    total_amount_in_cents = expenses.sum(:amount_in_cents)
    expenses = expenses.page(page).per(per_page)

    render json: ExpenseSerializer.new(expenses, {
      meta: {
        total: expenses.total_pages,
        total_amount_in_cents: total_amount_in_cents,
        years: Current.user.expenses.select("strftime('%Y', purchased_at) as year").distinct.map(&:year)
      },
      links: {
        first: "#{ENV["BACKEND_URL"]}/v1/expenses?page=1&per_page=#{per_page}",
        last: "#{ENV["BACKEND_URL"]}/v1/expenses?page=#{expenses.total_pages}&per_page=#{per_page}",
        prev: expenses.prev_page ? "#{ENV["BACKEND_URL"]}/v1/expenses?page=#{expenses.prev_page}&per_page=#{per_page}" : nil,
        next: expenses.next_page ? "#{ENV["BACKEND_URL"]}/v1/expenses?page=#{expenses.next_page}&per_page=#{per_page}" : nil
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
