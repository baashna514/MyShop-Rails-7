FactoryBot.define do
  factory :order_item do
    order_id { create(:order).id }
    product_id { create(:product).id }
    quantity { Faker::Number.between(from: 1, to: 10) }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end