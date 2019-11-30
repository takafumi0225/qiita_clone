FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:account) {|n| "#{n}_#{Faker::Internet.username}" }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    password { "Ab1#{Faker::Internet.password(min_length: 5, max_length: 28, mix_case: true)}" }
  end
end
