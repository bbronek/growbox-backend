class User < ApplicationRecord
  has_secure_password

  has_many :devices

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, length: {minimum: 8}, format: {with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}\z/, message: "must be at least 8 characters and include at least one letter and one number"}

  def generate_jwt
    JWT.encode({user_id: id, exp: Time.now.to_i + 1800}, Rails.application.secrets.secret_key_base)
  end

  def invalidate_token
    update_column(:token_version, token_version + 1)
  end
end
