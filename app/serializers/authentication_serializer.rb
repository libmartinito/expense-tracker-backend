class AuthenticationSerializer
  include JSONAPI::Serializer

  attribute :email

  attribute :token do |object|
    object.auth_token
  end
end
