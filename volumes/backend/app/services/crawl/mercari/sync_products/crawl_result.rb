# クロール結果クラス
module Crawl
  module Mercari
    module SyncProducts
      class CrawlResult
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :mercari_id, :string
        attribute :name, :string
        attribute :price, :integer
        attribute :thumbnail_url, :string
        attribute :published, :boolean

        validates :published, inclusion: { in: [true, false] }
        validates_presence_of :mercari_id, :name, :price, :thumbnail_url
      end
    end
  end
end
