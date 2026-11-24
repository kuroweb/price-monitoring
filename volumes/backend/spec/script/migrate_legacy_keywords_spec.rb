require "rails_helper"

RSpec.describe "script/migrate_legacy_keywords.rb" do # rubocop:disable RSpec/DescribeClass
  def run_script(*args)
    stub_const("ARGV", args)
    load Rails.root.join("script/migrate_legacy_keywords.rb")
  end

  it "旧文字列がない場合は候補0件を返す" do
    create(:product_monitoring_monitor, required_keywords: ["iPad Pro", "A,B"])
    expect { run_script }.to output(/product_monitoring_monitors.required_keywords: 0 candidate/).to_stdout
  end

  it "読み取りでは文字列を数えるだけで、確認済みの列だけを変換し再実行しても維持する" do
    original = "　iPad Pro, 64GB、iPad Pro\nWi-Fi "
    monitor = create(:product_monitoring_monitor, required_keywords: original, negative_keywords: ["A,B"])
    unconfirmed = create(:product_monitoring_monitor, required_keywords: "A,B")
    crawl = create(:product_monitoring_crawl_setting, negative_keywords: original)
    allow($stdin).to receive(:read).and_return(JSON.generate(original))

    expect { run_script }.to output(/product_monitoring_monitors.required_keywords: 2 candidate/).to_stdout
    expect(monitor.reload.required_keywords).to eq(original)
    expect(crawl.reload.negative_keywords).to eq(original)

    [[monitor, "required_keywords"], [crawl, "negative_keywords"]].each do |record, column|
      target = ["apply", record.class.table_name, record.id.to_s, column]
      expect { run_script(*target) }.to output("Converted one keyword column\n").to_stdout
      expect(record.reload.public_send(column)).to eq(["iPad Pro", "64GB", "Wi-Fi"])
      expect { run_script(*target) }.to output("Already converted\n").to_stdout
    end
    expect(monitor.reload.negative_keywords).to eq(["A,B"])
    expect(unconfirmed.reload.required_keywords).to eq("A,B")
  end

  it "確認後に変更された値や既存配列は上書きしない" do
    monitor = create(:product_monitoring_monitor, required_keywords: ["iPad Pro", "A,B"])
    allow($stdin).to receive(:read).and_return(JSON.generate("iPad Pro, 64GB"))
    target = ["apply", monitor.class.table_name, monitor.id.to_s, "required_keywords"]

    expect do
      expect { run_script(*target) }.to raise_error(SystemExit)
    end.to output("Current value differs from the verified legacy string\n").to_stderr
    expect(monitor.reload.required_keywords).to eq(["iPad Pro", "A,B"])
  end
end
