require "rails_helper"

RSpec.describe ProductMonitoring::CalculateAggregationResults do
  let(:product_aggregation_setting) do
    create(:product_aggregation_setting, required_keywords: ["phone"], max_price: 1_000)
  end
  let(:date) { Date.new(2026, 11, 1) }

  def bought(attributes)
    create(:product_crawl_result, sold: true, bought_date: date.in_time_zone.change(hour: 12), **attributes)
  end

  it "条件に合う購入を日ごとに平均し複数の設定で見つかった出品を一度だけ数える" do
    bought(external_id: "a", name: "Phone", price: 200)
    bought(external_id: "a", name: "Phone", price: 200)
    bought(external_id: "b", name: "phone case", price: 400)
    bought(external_id: "c", name: "Tablet", price: 100)
    bought(external_id: "d", name: "Phone", price: 5_000)
    create(:product_crawl_result, external_id: "e", name: "Phone", price: 300)
    bought(external_id: "f", name: "Phone", price: 900, excluded_at: Time.current)

    described_class.call(product_aggregation_setting:, start_date: date - 1, end_date: date)

    results = product_aggregation_setting.product_aggregation_results.order(:date)
    expect(results.map { |r| [r.date, r.average_purchase_price, r.purchase_count] }).to eq([
                                                                                             [date - 1, nil, 0],
                                                                                             [date, 300, 2]
                                                                                           ])
  end

  it "全角半角や空白の有無だけが必須語と異なる出品も購入件数に数える" do
    product_aggregation_setting.update!(required_keywords: ["iPad Pro"])
    bought(external_id: "a", name: "ｉＰａｄ Ｐｒｏ", price: 200)
    bought(external_id: "b", name: "iPadPro", price: 400)

    described_class.call(product_aggregation_setting:, start_date: date, end_date: date)

    expect(product_aggregation_setting.product_aggregation_results.sole).to have_attributes(
      average_purchase_price: 300, purchase_count: 2
    )
  end

  it "再計算時にその日の結果を上書きする" do
    bought(external_id: "a", name: "Phone", price: 200)
    described_class.call(product_aggregation_setting:, start_date: date, end_date: date)
    bought(external_id: "b", name: "Phone", price: 400)
    described_class.call(product_aggregation_setting:, start_date: date, end_date: date)
    expect(product_aggregation_setting.product_aggregation_results.sole).to have_attributes(
      average_purchase_price: 300, purchase_count: 2
    )
  end
end
