require "faker"

20.times do
  email = Faker::Internet.email
  password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 1, min_numeric: 1)

  User.create!(
    email: email,
    password: password,
    password_confirmation: password,
    login: Faker::Internet.username
  )
end
