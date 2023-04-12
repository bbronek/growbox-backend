require "faker"

puts "populate users..."

20.times do
  email = Faker::Internet.email
  password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 1, min_numeric: 1)

  User.create!(
    email: email,
    password: password,
    password_confirmation: password,
    login: Faker::Internet.username
  )

  print "."
end

puts ""

puts "populate devices..."

users = User.all
devices = []
10.times do |i|
  device = Device.create(name: "Device #{i + 1}", user: users.sample)
  devices << device

  print "."
end

puts ""

puts "populate device logs..."

devices.each do |device|
  50.times do
    DeviceLog.create(
      temp: rand(10..30),
      soil_hum: rand(100..1000),
      air_hum: rand(100..1000),
      light: rand(100..1000),
      device: device
    )

    print "."
  end
end
