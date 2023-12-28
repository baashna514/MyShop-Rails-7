FactoryBot.define do
  factory :product do
    p_name { Faker::Commerce.product_name }
    p_desc { Faker::Lorem.sentence }
    p_price { Faker::Commerce.price(range: 100.0..1000.0) }
  end
end
