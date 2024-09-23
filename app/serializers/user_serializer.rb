class UserSerializer
  include JSONAPI::Serializer

  attribute :username
  attribute :email
  attribute :created_at
  attribute :updated_at
end
