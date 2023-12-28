class Admin::DashboardController < ApplicationController
  before_action :require_user_authentication, :set_devise_variables, except: :login
  before_action :is_admin, except: :login

  def login
    @resource = User.new
    @resource_name = :user
    render 'admin/login'
  end

  def index
    authorize :user, :admin?
  end

  def users
    @users = User.where(:admin => false).all
    render 'admin/users/index'
  end

  def orders
    @orders = Order.includes(user: {}, order_items: [:product])
    render 'admin/orders/index'
  end

  def products
    @products = Product.includes(p_image_attachment: [:blob])
    render 'admin/products/index'
  end

  def new_product
    @product = Product.new
    render 'admin/products/new'
  end

  def create_product
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'Product was successfully created.'
      redirect_to admin_products_path
    else
      render 'admin/products/new'
    end
  end

  def delete_product
    @product = Product.find(params[:id])
    is_used, message = Product.check_product_use(@product)
    if is_used
      flash[:error] = message
    else
      if @product.p_image.attached?
        @product.p_image.purge
      end
      @product.destroy
      flash[:success] = 'Product and image wes successfully deleted.'
    end
    redirect_to admin_products_path
  end

  def edit_product
    @product = Product.find(params[:id])
    @is_edit = true
    render 'admin/products/new'
  end

  def remove_product_image
    @product = Product.find(params[:id])
    if @product.p_image
      @product.p_image.purge if @product.p_image.attached?
    end
    redirect_to admin_edit_product_path(@product), notice: 'Image was successfully removed.'
  end

  def update_product
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = 'Product was successfully updated.'
      redirect_to admin_products_path
    else
      flash[:error] = 'Product was not updated.'
      redirect_to admin_edit_product_path
    end
  end




  private

  def require_user_authentication
    unless user_authenticated?
      flash[:error] = 'You need to log in to perform this action.'
      redirect_to new_user_session_path
    end
  end

  def is_admin
    authorize :user, :admin?
  end

  def user_authenticated?
    user_signed_in?
  end

  def product_params
    params.require(:product).permit(:p_name, :p_desc, :p_price, :p_image, category_ids: [])
  end

  def set_devise_variables
    @resource = User.new
    @resource_name = :admin
  end


end
