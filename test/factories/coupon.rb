FactoryBot.define do
  factory :coupon do
    promotion
    sequence(:code) { |n| "#{promotion.code.upcase}-#{'%04d' % n}" }
    status { 0 }
  end
end