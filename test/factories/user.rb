FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@iugu.com.br"}
    password {'12345678'}
  end
end