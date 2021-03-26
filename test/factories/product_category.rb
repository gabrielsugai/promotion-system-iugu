FactoryBot.define do
  factory :product_category do
    name { 'Promo' }
    sequence(:code) { |n| "PROMO#{n}" }
  end
end