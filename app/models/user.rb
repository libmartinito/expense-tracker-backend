class User < ApplicationRecord
  has_many :expenses

  has_secure_password
  has_secure_token :auth_token

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
end
