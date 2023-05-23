require "faker"

puts "populate users..."

20.times do
  email = Faker::Internet.email
  password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 1, min_numeric: 1)

  User.create!(
    email: email,
    password: password,
    password_confirmation: password
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

puts ""
puts "populate plants..."

plants = []
devices.each do |d|
  3.times do
    plant = Plant.create!(
      name: Faker::Name.unique.name,
      user: d.user,
      device: d,
      light_min: rand(100..500),
      light_max: rand(500..1000),
      temp_min: rand(10..20),
      temp_max: rand(20..30),
      humidity_min: rand(30..60),
      humidity_max: rand(60..90),
      fertilizing: Faker::Lorem.sentence,
      repotting: Faker::Lorem.sentence,
      pruning: Faker::Lorem.sentence,
      common_diseases: Faker::Lorem.sentence,
      appearance: Faker::Lorem.sentence,
      blooming_time: Faker::Lorem.sentence,
      public: [true, false].sample,
      description: Faker::Lorem.paragraph
    )
    plants << plant

    print "."
  end
end

puts ""
puts "populate favorite plants..."

users.each do |user|
  random_plants = plants.sample(rand(1..5))
  random_plants.each do |plant|
    FavoritePlant.create(user: user, plant: plant)
    print "."
  end
end

puts ""
