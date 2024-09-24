class ExpenseSerializer
  include JSONAPI::Serializer

  attribute :item
  attribute :amount_in_cents
  attribute :currency
  attribute :purchased_at
  attribute :created_at
  attribute :updated_at
end
