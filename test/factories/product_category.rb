FactoryBot.define do
  factory :product_category do
    name { 'Promo' }
    sequence(:code) { |n| "#{name.upcase}#{n}" }
  end
end