require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Proxy do
  let(:cache) { ActiveSupport::Cache::MemoryStore.new }
  let(:http) { instance_double(Net::HTTP) }

  before do
    allow(Rails).to receive(:cache).and_return(cache)
    stub_const("ENV", ENV.to_h.merge("DYNAMIC_PROXY_LIST_URL" => "https://proxy-list.example/list.txt"))
    allow(Net::HTTP).to receive(:start).and_yield(http)
  end

  def respond_with(body)
    response = Net::HTTPOK.new("1.1", "200", "OK")
    allow(response).to receive(:body).and_return(body)
    allow(http).to receive(:request).and_return(response)
  end

  it "一覧から選んだプロキシをブラウザの設定にして返し、一覧をキャッシュすること" do
    respond_with("host1:8080:user:pass\n\n")

    expect(described_class.call).to eq(server: "host1:8080", username: "user", password: "pass")
    described_class.call
    expect(http).to have_received(:request).once
  end

  it "一覧が空なら失敗し、空の一覧はキャッシュしないこと" do
    respond_with("")

    expect { described_class.call }.to raise_error(described_class::Unavailable)
    expect { described_class.call }.to raise_error(described_class::Unavailable)
    expect(http).to have_received(:request).twice
  end

  it "一覧を取得できなければ失敗すること" do
    allow(http).to receive(:request).and_return(Net::HTTPServiceUnavailable.new("1.1", "503", "Unavailable"))

    expect { described_class.call }.to raise_error(described_class::Unavailable)
  end
end
