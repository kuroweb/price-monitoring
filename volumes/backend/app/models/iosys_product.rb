class IosysProduct < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates_presence_of :external_id, :name, :thumbnail_url

  ## scopes ##
  ## methods ##
end
