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
puts "populate devices not assigned to users ..."

10.times do |i|
  Device.create(name: "Device #{i + 1}")
  print "."
end

puts ""
puts "populate devices assigned to user ..."

users = User.all
assigned_devices = []
10.times do |i|
  device = Device.create(name: "Device #{i + 1}", user: users.sample)
  assigned_devices << device

  print "."
end

puts ""
puts "populate device logs..."

assigned_devices.each do |device|
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

plants = []
puts ""
puts "populate template plants..."

english_ivy = Plant.create!(
  name: "English Ivy",
  user_id: users.sample.id,
  device_id: nil,
  light_min: 1.0,
  light_max: 5.0,
  temp_min: -12.0,
  temp_max: 32.0,
  air_humidity_min: 0.4,
  air_humidity_max: 0.75,
  fertilizing: "Fertilize with a balanced houseplant food every 2 weeks during spring and summer.",
  repotting: "It's typically repotted every 2 years, or when the plant becomes root-bound.",
  pruning: "Regularly throughout the growing season to maintain its shape and size.",
  common_diseases: "Spider mites, aphids, scale, and leaf spot.",
  appearance: "It has dark-green, glossy leaves, typically shaped like an arrowhead, with pronounced veins.",
  blooming_time: "Typically in late summer, but indoor plants rarely bloom.",
  status: "public",
  created_at: Time.now,
  updated_at: Time.now,
  description: "A description of the English Ivy",
  soil_humidity_min: 0.1,
  soil_humidity_max: 0.9
)

print "."

monstera = Plant.create!(
  name: "Monstera Deliciosa",
  user_id: users.sample.id,
  device_id: nil,
  light_min: 1.0,
  light_max: 5.0,
  temp_min: 18.0,
  temp_max: 29.0,
  air_humidity_min: 0.4,
  air_humidity_max: 0.7,
  fertilizing: "Fertilize once a month during the growing season (spring and summer) with a balanced houseplant fertilizer.",
  repotting: "Every 2 years, or when the plant becomes root-bound.",
  pruning: "As needed to control the plant's size and shape, or to remove any yellowing leaves.",
  common_diseases: "Root rot (from overwatering), spider mites, and leaf spot.",
  appearance: "It's notable for its large, glossy green leaves with deep splits and holes.",
  blooming_time: "Mature plants bloom with unusual, arum-like flowers, but this is rare for indoor plants.",
  status: "public",
  created_at: Time.now,
  updated_at: Time.now,
  description: "A description of the Monstera Deliciosa",
  soil_humidity_min: 0.2,
  soil_humidity_max: 0.8
)

print "."

african_violet = Plant.create!(
  name: "African Violet",
  user_id: users.sample.id,
  device_id: nil,
  light_min: 1.0,
  light_max: 5.0,
  temp_min: 18.0,
  temp_max: 27.0,
  air_humidity_min: 0.4,
  air_humidity_max: 0.6,
  fertilizing: "Fertilize every two weeks during the growing season with a high phosphorus plant food.",
  repotting: "African Violets prefer to be root-bound, so only repot when necessary (typically every year or two).",
  pruning: "Remove spent flowers and damaged leaves as needed.",
  common_diseases: "Powdery mildew, botrytis, and root rot (from overwatering).",
  appearance: "Small, compact plant with fuzzy, oval leaves. Blooms with small, brightly colored flowers in shades of purple, pink, or white.",
  blooming_time: "With proper care, can bloom almost continuously throughout the year.",
  status: "public",
  created_at: Time.now,
  updated_at: Time.now,
  description: "A description of the African Violet",
  soil_humidity_min: 0.2,
  soil_humidity_max: 0.8
)

print "."
puts ""
puts "attach images to template plants..."

english_ivy.image.attach(
  io: File.open(Rails.root.join('lib', 'assets', 'images', 'english_ivy.png')),
  filename: 'english_ivy.png',
  content_type: 'image/png'
)

print "."

monstera.image.attach(
  io: File.open(Rails.root.join('lib', 'assets', 'images', 'monstera_deliciosa.png')),
  filename: 'monstera_deliciosa.png',
  content_type: 'image/png'
)

print "."

african_violet.image.attach(
  io: File.open(Rails.root.join('lib', 'assets', 'images', 'african_violet.png')),
  filename: 'african_violet.png',
  content_type: 'image/png'
)
print "."

puts ""
puts "populate devices assigned plants..."


assigned_devices.each do |d|
  3.times do
    plant = Plant.create!(
      name: Faker::Name.unique.name,
      user: d.user,
      device: d,
      light_min: rand(100..500),
      light_max: rand(500..1000),
      temp_min: rand(10..20),
      temp_max: rand(20..30),
      air_humidity_min: rand(30..60),
      air_humidity_max: rand(60..90),
      soil_humidity_max: rand(60..90),
      soil_humidity_min: rand(60..90),
      fertilizing: Faker::Lorem.sentence,
      repotting: Faker::Lorem.sentence,
      pruning: Faker::Lorem.sentence,
      common_diseases: Faker::Lorem.sentence,
      appearance: Faker::Lorem.sentence,
      blooming_time: Faker::Lorem.sentence,
      status: "assigned",
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
