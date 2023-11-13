class Product < ApplicationRecord
  belongs_to :user

  has_one :crawl_setting

  has_many :price_versions
  has_many :crawl_histories
end
