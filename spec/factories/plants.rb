FactoryBot.define do
  factory :plant do
    name { "MyString" }
    user { nil }
    device { nil }
    light_min { 1.5 }
    light_max { 1.5 }
    temp_min { 1.5 }
    temp_max { 1.5 }
    humidity_min { 1.5 }
    humidity_max { 1.5 }
    fertilizing { "MyText" }
    repotting { "MyText" }
    pruning { "MyText" }
    common_diseases { "MyText" }
    appearance { "MyText" }
    blooming_time { "MyText" }
    image { "MyString" }
    public { false }
  end
end
