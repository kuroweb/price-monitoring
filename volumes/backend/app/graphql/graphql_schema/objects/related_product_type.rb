module GraphqlSchema
  module Objects
    class RelatedProductType < Base
      field :platform, String, null: false
      field :product_id, Int, null: false
      field :external_id, String, null: false
      field :name, String, null: false
      field :thumbnail_url, String, null: false
      field :price, Int, null: false
      field :buyout_price, Int, null: true
      field :published, Boolean, null: false
      field :bought_date, String, null: true
      field :end_date, String, null: true
      field :created_at, String, null: false
      field :updated_at, String, null: false
    end
  end
end
