require 'rails_helper'

RSpec.describe "Routes", type: :routing do
  context "Health Check" do
    it "routes GET /up to rails/health#show" do
      expect(get: "/up").to route_to("rails/health#show")
    end
  end

  context "Root" do
    it "routes the root path to product#index" do
      expect(get: "/").to route_to("product#index")
    end
  end

  context "User Authentication" do
    it "routes GET /login to users#user_login" do
      expect(get: "/login").to route_to("users#user_login")
    end

    it "routes POST /login to users#check_credentials" do
      expect(post: "/login").to route_to("users#check_credentials")
    end

    it "routes GET /logout to users#logout" do
      expect(get: "/logout").to route_to("users#logout")
    end

    it "routes GET /my-profile to users#profile" do
      expect(get: "/my-profile").to route_to("users#profile")
    end

    it "routes GET /edit-profile to users#edit_profile" do
      expect(get: "/edit-profile").to route_to("users#edit_profile")
    end

    it "routes POST /update-profile/:id to users#update_profile" do
      user = create(:user)
      expect(post: "/update-profile/#{user.id}").to route_to("users#update_profile", id: user.id.to_s)
    end

    it "routes GET /reset_password to users#new_password_reset" do
      expect(get: "/reset_password").to route_to("users#new_password_reset")
    end

    it "routes POST /reset-password-action to users#create_password_reset" do
      expect(post: "/reset-password-action").to route_to("users#create_password_reset")
    end

    it "routes GET /reset_password/:token/edit to users#edit_password_reset" do
      user = create(:user, reset_password_token: SecureRandom.urlsafe_base64, reset_password_sent_at: Time.zone.now)
      expect(get: "/reset_password/#{user.reset_password_token}/edit").to route_to("users#edit_password_reset", token: user.reset_password_token)
    end

    it "routes PATCH /reset_password/:token to users#update_password_reset" do
      user = create(:user, reset_password_token: SecureRandom.urlsafe_base64, reset_password_sent_at: Time.zone.now)
      expect(patch: "/reset_password/#{user.reset_password_token}").to route_to("users#update_password_reset", token: user.reset_password_token)
    end

    it "routes GET /sign-up to users#sign_up_form" do
      expect(get: "/sign-up").to route_to("users#sign_up_form")
    end

    it "routes POST /create-users to users#create_user" do
      expect(post: "/create-users").to route_to("users#create_user")
    end

  end

  context "Shopping Cart" do
    it "routes GET /cart to cart#index" do
      expect(get: "/cart").to route_to("cart#index")
    end

    it "routes POST /add_to_cart/:id to cart#add_to_cart" do
      cart = create(:cart)
      expect(post: "/add_to_cart/#{cart.id}").to route_to("cart#add_to_cart", id: cart.id.to_s)
    end

    it "routes GET /delete_cart/:id to cart#delete_cart" do
      cart = create(:cart)
      expect(get: "/delete_cart/#{cart.id}").to route_to("cart#delete_cart", id: cart.id.to_s)
    end

    it "routes GET /checkout to cart#checkout" do
      expect(get: "/checkout").to route_to("cart#checkout")
    end

  end

  context "Order Placement" do
    it "routes POST /place-an-order to order#place_order" do
      expect(post: "/place-an-order").to route_to("order#place_order")
    end
  end

  context "Admin Dashboard" do
    it "routes GET /admin/dashboard/index to admin/dashboard#index" do
      expect(get: "/admin/dashboard/index").to route_to("admin/dashboard#index")
    end

    it "routes GET /admin/users to admin/dashboard#users" do
      expect(get: "/admin/users").to route_to("admin/dashboard#users")
    end

    it "routes GET /admin/orders to admin/dashboard#orders" do
      expect(get: "/admin/orders").to route_to("admin/dashboard#orders")
    end

    it "routes GET /admin/products to admin/dashboard#products" do
      expect(get: "/admin/products").to route_to("admin/dashboard#products")
    end

    it "routes GET /admin/product/new to admin/dashboard#new_product" do
      expect(get: "/admin/product/new").to route_to("admin/dashboard#new_product")
    end

    it "routes POST /admin/product/create to admin/dashboard#create_product" do
      expect(post: "/admin/product/create").to route_to("admin/dashboard#create_product")
    end

    it "routes GET /admin/product/delete/:id to admin/dashboard#delete_product" do
      product = create(:product)
      expect(get: "/admin/product/delete/#{product.id}").to route_to("admin/dashboard#delete_product", id: product.id.to_s)
    end

    it "routes GET /admin/product/edit/:id to admin/dashboard#edit_product" do
      product = create(:product)
      expect(get: "/admin/product/edit/#{product.id}").to route_to("admin/dashboard#edit_product", id: product.id.to_s)
    end

    it "routes GET /admin/product/:id/remove-image to admin/dashboard#remove_product_image" do
      product = create(:product)
      expect(get: "/admin/product/#{product.id}/remove-image").to route_to("admin/dashboard#remove_product_image", id: product.id.to_s)
    end

    it "routes PATCH /admin/product/update/:id to admin/dashboard#update_product" do
      product = create(:product)
      expect(patch: "/admin/product/update/#{product.id}").to route_to("admin/dashboard#update_product", id: product.id.to_s)
    end

  end
end
