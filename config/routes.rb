Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "product#index"
  get '/product-detail/:product_name', to: 'product#productDetail', as: 'product_detail'

  get '/category/:category_name/products/', to: 'product#categoryProducts', as: 'category_products'

  devise_for :users

  # get '/login', to: 'user#user_login', as: 'login'
  # post "/login" => "user#check_credentials", as: :check_credentials
  # get "/logout" => "user#logout", as: :logout

  get '/my-profile', to: 'user#profile', as: 'user_profile'
  get '/edit-profile', to: 'user#edit_profile', as: 'edit_profile'
  post '/update-profile/:id', to: 'user#update_profile', as: 'update_profile'


  get '/reset_password', to: 'user#new_password_reset', as: 'new_password_reset'
  post '/reset-password-action', to: 'user#create_password_reset', as: 'password_reset'
  get '/reset_password/:token/edit', to: 'user#edit_password_reset', as: :edit_password_reset
  patch '/reset_password/:token', to: 'user#update_password_reset', as: :reset_password


  get '/sign-up', to: 'user#sign_up_form', as: 'sign_up'
  post '/create-user', to: 'user#create_user', as: 'create_user'

  get '/cart', to: 'cart#index', as: 'my_cart'
  post '/add_to_cart/:id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get '/delete_cart/:id', to: 'cart#delete_cart', as: 'delete_cart'
  get '/checkout', to: 'cart#checkout', as: 'checkout'

  post '/place-an-order', to: 'order#place_order', as: 'place_an_order'

  namespace :admin do
    get '/', to: 'dashboard#login', as: 'login'
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    get 'users', to: 'dashboard#users', as: 'users'
    get 'orders', to: 'dashboard#orders', as: 'orders'
    get 'products', to: 'dashboard#products', as: 'products'
    get 'product/new', to: 'dashboard#new_product', as: 'add_product'
    post 'product/create', to: 'dashboard#create_product', as: 'create_product'
    get 'product/delete/:id', to: 'dashboard#delete_product', as: 'delete_product'
    get 'product/edit/:id', to: 'dashboard#edit_product', as: 'edit_product'
    get 'product/:id/remove-image', to: 'dashboard#remove_product_image', as: 'remove_product_image'
    patch 'product/update/:id', to: 'dashboard#update_product', as: 'update_product'

    resources :categories do
      member do
        get 'delete_category', to: 'categories#destroy_category', as: 'delete_category'
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
