FactoryBot.define do
  factory :cart do
    product_id { create(:product).id }
    user_id { create(:user).id }
    quantity { Faker::Number.between(from: 1, to: 10) }
  end
end
