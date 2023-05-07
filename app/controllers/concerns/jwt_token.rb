module JwtToken
  def decode_jwt(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
  rescue
    nil
  end
end
