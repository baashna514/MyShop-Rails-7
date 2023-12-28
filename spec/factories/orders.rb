FactoryBot.define do
  factory :order do
    user_id { create(:user).id }
    order_date { Time.current }
    total { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    status { 'pending' }
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    payment_method { 'Cash On Delivery' }

    transient do
      order_items_count { 2 }
    end

    after(:build) do |order, evaluator|
      order.order_items = build_list(:order_item, evaluator.order_items_count, order: order)
    end

  end
end
