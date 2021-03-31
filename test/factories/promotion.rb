FactoryBot.define do
  factory :promotion do
    user
    name { 'Promo' }
    description { 'Promocao teste' }
    sequence(:discount_rate) { |n| n*5 }
    code { "#{name.split.join.upcase}#{discount_rate}" }
    coupon_quantity { 100 }
    expiration_date { "#{1.day.from_now}" }
  end
end