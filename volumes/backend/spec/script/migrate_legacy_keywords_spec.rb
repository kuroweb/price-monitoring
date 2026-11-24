require "rails_helper"

RSpec.describe "script/migrate_legacy_keywords.rb" do # rubocop:disable RSpec/DescribeClass
  def run_script
    load Rails.root.join("script/migrate_legacy_keywords.rb")
  end

  it "旧カンマ区切りの文字列を語句配列にし、既存配列は変えず、再実行しても変わらない" do
    monitor = create(
      :product_monitoring_monitor, required_keywords: "　iPad Pro, 64GB、\nWi-Fi ", negative_keywords: ["A,B"]
    )
    crawl = create(:product_monitoring_crawl_setting, required_keywords: ["iPad Pro"], negative_keywords: "ジャンク,")

    expect { run_script }.to output(/product_monitoring_monitors.required_keywords: 1 updated/).to_stdout
    expect(monitor.reload.required_keywords).to eq(["iPad Pro", "64GB", "Wi-Fi"])
    expect(monitor.negative_keywords).to eq(["A,B"])
    expect(crawl.reload.required_keywords).to eq(["iPad Pro"])
    expect(crawl.negative_keywords).to eq(["ジャンク"])

    expect { run_script }.to output(/product_monitoring_monitors.required_keywords: 0 updated/).to_stdout
    expect(monitor.reload.required_keywords).to eq(["iPad Pro", "64GB", "Wi-Fi"])
    expect(crawl.reload.negative_keywords).to eq(["ジャンク"])
  end
end
