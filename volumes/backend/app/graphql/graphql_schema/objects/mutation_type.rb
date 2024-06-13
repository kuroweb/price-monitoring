module GraphqlSchema
  module Objects
    class MutationType < Base
      field :create_product, mutation: Mutations::Products::CreateProduct
      field :update_product, mutation: Mutations::Products::UpdateProduct
      field :delete_product, mutation: Mutations::Products::DeleteProduct
      field :create_yahoo_auction_crawl_setting_exclude_keyword,
            mutation: Mutations::Products::CreateYahooAuctionCrawlSettingExcludeKeyword
    end
  end
end
