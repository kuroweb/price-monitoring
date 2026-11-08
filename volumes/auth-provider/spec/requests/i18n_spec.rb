require "rails_helper"

RSpec.describe I18n do
  it "Rails 標準のバリデーションメッセージを日本語で取得できること" do
    expect(described_class.t("errors.messages.inclusion")).to eq("は一覧にありません")
    expect(described_class.t("errors.messages.not_an_integer")).to eq("は整数で入力してください")
  end

  it "日付と時刻を日本語の標準書式で表示できること" do
    date = Date.new(2026, 11, 8)
    time = Time.zone.local(2026, 11, 8, 12, 30)

    expect(described_class.l(date)).to eq("2026/11/08")
    expect(described_class.l(time)).to include("2026年11月08日(日) 12時30分00秒")
  end
end
