FactoryBot.define do
  factory :token, class: "Token" do
    value { SecureRandom.hex }
    expires  { 1.hour.from_now }
  end

  factory :expired_token, class: "Token" do
    value { SecureRandom.hex }
    expires  { 2.hours.ago }
  end

  factory :john_cena, class: "User" do
    name { "john cena" }
  end

  factory :razrushitel, class: "User" do
    name { "razrushitel" }
  end

  factory :unnamed, class: "User" do
    name { "unnamed" }
  end
end
