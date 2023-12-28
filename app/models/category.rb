class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_ancestry
  has_one_attached :image

  validates :title, presence: true

  has_many :categorizations
  has_many :products, through: :categorizations
end
