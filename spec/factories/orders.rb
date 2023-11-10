# frozen_srting_literal: true

FactoryBot.define do
  factory :order do
    sequence(:user_id) { |n| n }
    amount { 100 }
    date { Date.today }
  end
end
