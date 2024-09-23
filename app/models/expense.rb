class Expense < ApplicationRecord
  belongs_to :user

  validates :item, presence: true
  validates :amount_in_cents, presence: true
  validates :currency, presence: true
  validates :purchased_at, presence: true
end
