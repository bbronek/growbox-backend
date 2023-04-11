require "bcrypt"
require "jwt"

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :login, presence: true, uniqueness: true

  def generate_jwt
    JWT.encode({user_id: id, exp: Time.now.to_i + 1800}, Rails.application.secrets.secret_key_base)
  end
end
