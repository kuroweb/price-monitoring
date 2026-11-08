require "rails_helper"

RSpec.describe ProductMonitoring::Sites::BrowserPage do
  it "許可されたホストの HTTPS URL を受け入れること" do
    page = instance_double(Playwright::Page, url: "https://jp.mercari.com/search?keyword=phone")
    expect { described_class.validate_url(page, host: "jp.mercari.com") }.not_to raise_error
  end

  it "異なるホスト、スキーム、ポート、認証情報を拒否すること" do
    [
      "https://example.com/search",
      "http://jp.mercari.com/search",
      "https://jp.mercari.com:8443/search",
      "https://user@jp.mercari.com/search"
    ].each do |url|
      page = instance_double(Playwright::Page, url: url)
      expect { described_class.validate_url(page, host: "jp.mercari.com") }.to raise_error(/Unexpected page URL/)
    end
  end

  describe ".fetch" do
    let(:uri) { URI("https://ec.treasure-f.com/search?word=x") }
    let(:page) { instance_double(Playwright::Page, url: uri.to_s, content: "ok") }
    let(:response) { instance_double(Playwright::Response, status: 200) }

    before do
      allow(page).to receive(:goto).and_return(response)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
    end

    it "プロキシを設定する Crawl::Client でスクリプトを止めて取得すること" do
      expect(described_class.fetch(uri, host: uri.host, max_bytes: 10, user_agent: "UA")).to eq("ok")
      expect(Crawl::Client).to have_received(:execute).with(block_scripts: true, user_agent: "UA")
    end

    it "非 2xx の応答では接続し直して試し、上限回数で失敗にすること" do
      allow(Kernel).to receive(:sleep)
      allow(response).to receive(:status).and_return(403, 200)
      expect(described_class.fetch(uri, host: uri.host, max_bytes: 10)).to eq("ok")
      expect(Crawl::Client).to have_received(:execute).twice
      allow(response).to receive(:status).and_return(403)
      expect { described_class.fetch(uri, host: uri.host, max_bytes: 10) }.to raise_error(/Non-success/)
      expect(Crawl::Client).to have_received(:execute).exactly(2 + described_class::FETCH_TRIES).times
    end

    it "許可していない最終ホストと上限を超える HTML を拒否し、接続し直さないこと" do
      allow(page).to receive(:url).and_return("https://evil.example/")
      expect { described_class.fetch(uri, host: uri.host, max_bytes: 10) }.to raise_error(/Unexpected page URL/)
      allow(page).to receive(:url).and_return(uri.to_s)
      expect { described_class.fetch(uri, host: uri.host, max_bytes: 1) }.to raise_error(/size limit/)
      expect(Crawl::Client).to have_received(:execute).twice
    end
  end
end
