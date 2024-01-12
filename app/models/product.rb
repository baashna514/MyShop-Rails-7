class Product < ApplicationRecord
  validates :p_name, presence: true
  validates :p_desc, presence: true
  validates :p_price, presence: true

  has_many :carts
  has_many :order_items
  has_one_attached :p_image, dependent: :destroy
  attr_accessor :image_url
  paginates_per 12


  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  def has_orders?
    order_items.any?
  end

  def has_carts?
    carts.any?
  end

  def self.check_product_use(product)
    if product.has_orders? || product.has_carts?
      return true, "You can't delete this product, it is already in use somewhere."
    else
      return false, nil
    end
  end


  def self.ransackable_attributes(auth_object = nil)
    %w[p_name]
  end

end
