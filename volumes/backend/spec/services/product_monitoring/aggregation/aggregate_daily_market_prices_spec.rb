require "rails_helper"

RSpec.describe ProductMonitoring::Aggregation::AggregateDailyMarketPrices do
  let(:monitor) do
    create(:product_monitoring_monitor, required_keywords: ["phone"], max_price: 1_000)
  end
  let(:date) { Date.new(2026, 11, 1) }

  def bought(attributes)
    create(:product_monitoring_crawl_result, sold: true, sold_at: date.in_time_zone.change(hour: 12), **attributes)
  end

  it "抽出条件に合う取引を日ごとに平均し複数の収集設定で見つかった出品を一度だけ数えること" do
    bought(external_id: "a", name: "Phone", price: 200)
    bought(external_id: "a", name: "Phone", price: 200)
    bought(external_id: "b", name: "phone case", price: 400)
    bought(external_id: "c", name: "Tablet", price: 100)
    bought(external_id: "d", name: "Phone", price: 5_000)
    create(:product_monitoring_crawl_result, external_id: "e", name: "Phone", price: 300)
    bought(external_id: "f", name: "Phone", price: 900, excluded_at: Time.current)

    described_class.call(monitor:, start_date: date - 1, end_date: date)

    results = monitor.daily_market_prices.order(:date)
    expect(results.map { |r| [r.date, r.average_transaction_price, r.transaction_count] }).to eq([
                                                                                                   [date - 1, nil, 0],
                                                                                                   [date, 300, 2]
                                                                                                 ])
  end

  it "全角半角や空白の有無だけが必須語と異なる出品も取引件数に数えること" do
    monitor.update!(required_keywords: ["iPad Pro"])
    bought(external_id: "a", name: "ｉＰａｄ Ｐｒｏ", price: 200)
    bought(external_id: "b", name: "iPadPro", price: 400)

    described_class.call(monitor:, start_date: date, end_date: date)

    expect(monitor.daily_market_prices.sole).to have_attributes(
      average_transaction_price: 300, transaction_count: 2
    )
  end

  it "再計算時にその日の結果を上書きすること" do
    bought(external_id: "a", name: "Phone", price: 200)
    described_class.call(monitor:, start_date: date, end_date: date)
    bought(external_id: "b", name: "Phone", price: 400)
    described_class.call(monitor:, start_date: date, end_date: date)
    expect(monitor.daily_market_prices.sole).to have_attributes(
      average_transaction_price: 300, transaction_count: 2
    )
  end

  it "異なる設定の同じ日付をそれぞれ保存すること" do
    other = create(:product_monitoring_monitor, required_keywords: ["tablet"])
    bought(external_id: "a", name: "Phone", price: 200)
    bought(external_id: "b", name: "Tablet", price: 400)
    described_class.call(monitor:, start_date: date, end_date: date)
    described_class.call(monitor: other, start_date: date, end_date: date)
    expect(monitor.daily_market_prices.sole.average_transaction_price).to eq(200)
    expect(other.daily_market_prices.sole.average_transaction_price).to eq(400)
  end

  it "除外する出品者の取引を、出品者IDが不明な別の収集設定の同じ出品も含めて数えず、解除後の再集計で戻すこと" do
    seller = create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
    bought(platform: "mercari", external_id: "a", name: "Phone", price: 900, seller_id: nil)
    bought(platform: "mercari", external_id: "a", name: "Phone", price: 900, seller_id: "Seller_1")
    bought(platform: "mercari", external_id: "b", name: "Phone", price: 200, seller_id: nil)
    bought(platform: "mercari", external_id: "c", name: "Phone", price: 400, seller_id: "Seller_2")
    bought(platform: "mercari", external_id: "d", name: "Phone", price: 100, seller_id: "Seller_2",
           excluded_at: Time.current)

    described_class.call(monitor:, start_date: date, end_date: date)
    expect(monitor.daily_market_prices.sole).to have_attributes(average_transaction_price: 300, transaction_count: 2)

    seller.destroy!
    described_class.call(monitor:, start_date: date, end_date: date)
    expect(monitor.daily_market_prices.sole).to have_attributes(average_transaction_price: 500, transaction_count: 3)
  end
end
