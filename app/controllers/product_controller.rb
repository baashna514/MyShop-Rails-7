class ProductController < ApplicationController
  def index


      puts "Ransack parameters: #{params[:q]}"
      @q = Product.includes(:categories, p_image_attachment: [:blob]).ransack(params[:q])
      @products_data = @q.result(distinct: true).page(params[:page])

      @serialized_products = @products_data.map do |product|
        product_url = "http://localhost:3000" + "#{rails_blob_path(product.p_image, only_path: true)}"
        product.define_singleton_method(:image_url) { product_url }
        product
      end

      @products = Rails.cache.fetch('products', expires_in: 1.hour) do
        @serialized_products
      end

      @categories = Rails.cache.fetch('categories', expires_in: 1.hour) do
        Category.includes(image_attachment: [:blob]).order(Arel.sql('RANDOM()')).limit(8)
      end

  end

  def categoryProducts
    @categories = Category.all
    if params[:category_ids].present?
      category_ids = params[:category_ids]
      @products = Product.includes(p_image_attachment: [:blob]).joins(:categories).where(categories: { id: category_ids }).distinct
    else
      @category = Category.find_by(title: params[:category_name])
      @products = @category.products.includes(p_image_attachment: [:blob]).page(params[:page])
    end
    @product_count = @products.count
    render 'product/category_products'
  end

  def productDetail
    @product = Product.find_by(p_name: params[:product_name])
    categories = @product.categories
    @related_products = Product.includes(p_image_attachment: [:blob]).joins(:categories).where(categories: { id: categories }).distinct
    render 'product/product_detail'
  end

end
