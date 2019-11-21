FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: Random.new.rand(1..100) }
    body { Faker::Lorem.paragraph(sentence_count: 20) }
    user
  end
end
