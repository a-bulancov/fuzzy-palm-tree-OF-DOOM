FactoryBot.define do
  factory :order do
    order_date { Time.now }
    price { 10.11 }
    user
  end
end