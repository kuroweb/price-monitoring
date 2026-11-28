require "rails_helper"

RSpec.describe ProductMonitoring::CrawlResult do
  describe ".not_excluded_seller" do
    def result(platform, external_id, seller_id, **attributes)
      create(:product_monitoring_crawl_result, platform:, external_id:, seller_id:, **attributes)
    end

    it "除外する出品者の出品を、出品者IDが不明な別の収集設定の同じ出品も含めて除き、出品者IDが不明な出品は残すこと" do
      create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
      excluded = result("mercari", "m1", "Seller_1")
      same_listing = result("mercari", "m1", nil)
      unknown = result("mercari", "m2", nil)
      other_seller = result("mercari", "m3", "Seller_2")

      expect(described_class.not_excluded_seller).to contain_exactly(unknown, other_seller)
      expect(described_class.where(id: [excluded.id, same_listing.id]).count).to eq(2)
    end

    it "出品者IDはサイトごとに大文字小文字まで完全一致で照合すること" do
      create(:product_monitoring_excluded_seller, platform: "yahoo_auction", seller_id: "Seller_1")
      excluded = result("yahoo_auction", "a1", "Seller_1")
      case_differs = result("yahoo_auction", "a2", "seller_1")
      prefix = result("yahoo_auction", "a3", "Seller_10")
      other_site = result("yahoo_fleamarket", "a1", "Seller_1")

      expect(described_class.not_excluded_seller).to contain_exactly(case_differs, prefix, other_site)
      expect(described_class.not_excluded_seller).not_to include(excluded)
    end

    it "収集結果ごとの除外とは独立し、解除すると再び対象になること" do
      seller = create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
      listing = result("mercari", "m1", "Seller_1")
      manually_excluded = result("mercari", "m2", nil, excluded_at: Time.current)

      expect(described_class.not_excluded.not_excluded_seller).to be_empty
      seller.destroy!
      expect(described_class.not_excluded.not_excluded_seller).to contain_exactly(listing)
      expect(manually_excluded.reload.excluded_at).to be_present
    end
  end
end
