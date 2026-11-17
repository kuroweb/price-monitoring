require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Iosys::ListPage::Syncer do
  include ActiveSupport::Testing::TimeHelpers

  let(:crawl_setting) { create(:product_monitoring_crawl_setting, required_keywords: ["phone"]) }
  let(:listings) do
    [
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a",
        thumbnail_url: "https://iosys.co.jp/a.jpg", sold: false },
      { external_id: "b", name: "Case", price: 100, product_url: "https://iosys.co.jp/items/b", sold: false },
      { external_id: "excluded", name: "Phone red", price: 300, product_url: "https://iosys.co.jp/items/excluded",
        sold: false }
    ]
  end
  let(:complete) { true }

  before do
    allow(ProductMonitoring::Crawling::Iosys::ListPage::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "iosys") }, complete: }
    end
  end

  def results
    crawl_setting.crawl_results
  end

  describe "保存" do
    it "条件に合う出品だけをサイトとともに保存すること" do
      described_class.call(crawl_setting:)
      expect(results.pluck(:external_id)).to contain_exactly("a", "excluded")
      expect(results.find_by(external_id: "a")).to have_attributes(
        platform: "iosys", product_url: "https://iosys.co.jp/items/a", price: 100, thumbnail_url: "https://iosys.co.jp/a.jpg"
      )
    end

    it "削除された出品を再取得すると再登録すること" do
      create(:product_monitoring_crawl_result, crawl_setting:, external_id: "a", name: "Phone old").destroy!
      described_class.call(crawl_setting:)
      expect(results.find_by!(external_id: "a")).to have_attributes(name: "Phone blue", excluded_at: nil)
    end

    it "除外済み出品の除外状態を保って価格を更新すること" do
      excluded_at = 1.day.ago.change(usec: 0)
      create(:product_monitoring_crawl_result, crawl_setting:, external_id: "excluded", name: "Phone red", price: 100,
                                               excluded_at:)
      described_class.call(crawl_setting:)
      expect(results.find_by(external_id: "excluded")).to have_attributes(price: 300, excluded_at:)
    end

    it "除外済み出品が101件以上あっても保存すること" do
      create_list(:product_monitoring_crawl_result, 101, crawl_setting:, name: "Phone", excluded_at: 1.day.ago)
      create(:product_monitoring_crawl_result, crawl_setting:, external_id: "excluded", name: "Phone red", price: 100,
                                               excluded_at: 1.day.ago)
      described_class.call(crawl_setting:)
      expect(results.find_by(external_id: "excluded").price).to eq(300)
    end

    it "今回の一覧にない出品を残し、条件に合わなくなった出品を削除すること" do
      kept = create(:product_monitoring_crawl_result, crawl_setting:, external_id: "sold", name: "Phone sold",
                                                      updated_at: 1.hour.ago)
      create(:product_monitoring_crawl_result, crawl_setting:, external_id: "unmatched", name: "Case")
      described_class.call(crawl_setting:)
      expect(results.pluck(:external_id)).to contain_exactly("a", "excluded", kept.external_id)
    end

    it "既存の出品を重複させずに更新すること" do
      create(:product_monitoring_crawl_result, crawl_setting:, external_id: "a", name: "Phone old", price: 50)
      described_class.call(crawl_setting:)
      expect(results.where(external_id: "a").sole).to have_attributes(name: "Phone blue", price: 100)
    end

    it "価格のない出品は保存せず既存行を保ち、0円は保存すること" do
      existing = create(:product_monitoring_crawl_result, crawl_setting:, external_id: "a", name: "Phone old",
                                                          price: 50)
      listings.replace([
                         { external_id: "a", name: "Phone new", price: nil,
                           product_url: "https://iosys.co.jp/items/a" },
                         { external_id: "missing", name: "Phone", price: nil,
                           product_url: "https://iosys.co.jp/items/m" },
                         { external_id: "free", name: "Phone", price: 0, product_url: "https://iosys.co.jp/items/free" }
                       ])
      described_class.call(crawl_setting:)
      expect(existing.reload).to have_attributes(name: "Phone old", price: 50)
      expect(results.pluck(:external_id)).to contain_exactly("a", "free")
    end

    it "保存後の処理が途中で失敗した場合は先に行った状態更新を戻すこと" do
      listing = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", external_id: "missing",
                                                         name: "Phone", sold: false, updated_at: 4.hours.ago)
      listings.clear
      allow(ProductMonitoring::Crawling::CrawlResultCleaner).to receive(:call) do
        expect(listing.reload.sold).to be true
        raise "failed"
      end

      expect { described_class.call(crawl_setting:) }.to raise_error("failed")
      expect(listing.reload.sold).to be false
    end
  end

  describe "販売状態" do
    let(:crawl_setting) { create(:product_monitoring_crawl_setting) }

    it "一覧に戻った売り切れの出品を販売中にし、売れた日は保つこと" do
      sold_at = 2.days.ago.change(usec: 0)
      listing = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", external_id: "a",
                                                         sold: true,
                                                         sold_at:)
      described_class.call(crawl_setting:)
      expect(listing.reload).to have_attributes(sold: false, sold_at:)
    end

    it "一覧から消えた古い出品を売り切れにし、日時と他のサイト・設定は変えないこと" do
      updated_at = 4.hours.ago.change(usec: 0)
      missing = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", external_id: "missing",
                                                         sold: false, updated_at:)
      other_site = create(:product_monitoring_crawl_result, crawl_setting:, platform: "janpara", external_id: "other",
                                                            sold: false, updated_at:)
      other_setting = create(:product_monitoring_crawl_result, platform: "iosys", external_id: "elsewhere", sold: false,
                                                               updated_at:)

      described_class.call(crawl_setting:)

      expect(missing.reload).to have_attributes(sold: true, sold_at: nil, updated_at:)
      expect(other_site.reload.sold).to be false
      expect(other_setting.reload.sold).to be false
    end

    it "価格がなくても一覧にある出品は売り切れにしないこと" do
      listing = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", external_id: "a",
                                                         sold: false,
                                                         updated_at: 4.hours.ago)
      listings.first[:price] = nil
      described_class.call(crawl_setting:)
      expect(listing.reload.sold).to be false
    end

    context "一覧を最後まで取得できなかったとき" do
      let(:complete) { false }

      it "一覧から消えた出品を売り切れにしないこと" do
        listing = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", sold: false,
                                                           updated_at: 4.hours.ago)
        described_class.call(crawl_setting:)
        expect(listing.reload.sold).to be false
      end
    end

    it "3時間ちょうどで売り切れにし、それより新しい出品は保つこと" do
      travel_to Time.current.change(usec: 0) do
        old = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", sold: false,
                                                       updated_at: 3.hours.ago)
        recent = create(:product_monitoring_crawl_result, crawl_setting:, platform: "iosys", sold: false,
                                                          updated_at: 3.hours.ago + 1.second)

        described_class.call(crawl_setting:)

        expect(old.reload.sold).to be true
        expect(recent.reload.sold).to be false
      end
    end
  end
end
