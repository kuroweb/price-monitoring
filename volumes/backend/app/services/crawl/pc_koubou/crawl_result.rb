module Crawl
  module PcKoubou
    class CrawlResult
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :pc_koubou_id, :string
      attribute :name, :string
      attribute :price, :integer
      attribute :thumbnail_url, :string

      validates_presence_of :pc_koubou_id, :name, :price, :thumbnail_url
    end
  end
end
