FactoryBot.define do
  factory :promotion do
    user
    name { 'Promo' }
    description { 'Promocao teste' }
    sequence(:code) { |n| "#{name.split.join.upcase}#{n*5}" }
    sequence(:discount_rate) { |n| n*5 }
    coupon_quantity { 100 }
    expiration_date { "#{1.day.from_now}" }
  end
end