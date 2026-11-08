require "rails_helper"

RSpec.describe Crawl::Client, type: :service do
  describe ".execute" do
    let(:page) { instance_double(Playwright::Page) }
    let(:context) { instance_double(Playwright::BrowserContext, new_page: page) }
    let(:browser) { instance_double(Playwright::Browser, new_context: context) }
    let(:route_handler) { {} }
    let(:proxy) { { server: "proxy.example:8080", username: "user", password: "pass" } }

    before do
      stub_const("ENV", ENV.to_h.merge("PLAYWRIGHT_URL" => "ws://playwright"))
      allow(Crawl::DynamicProxy).to receive(:get).and_return(proxy)
      allow(Playwright).to receive(:connect_to_browser_server).and_yield(browser)
      allow(page).to receive(:route) { |_pattern, handler| route_handler[:call] = handler }
    end

    def route_for(url:, resource_type:, **)
      route = instance_double(Playwright::Route, abort: nil, fallback: nil)
      request = instance_double(Playwright::Request, url:, resource_type:)

      described_class.execute(**) { route_handler[:call].call(route, request) }
      route
    end

    it "画像とフォントは常にブロックすること" do
      expect(route_for(url: "https://example.com/a.png", resource_type: "image")).to have_received(:abort)
      expect(route_for(url: "https://example.com/a.woff2", resource_type: "font")).to have_received(:abort)
    end

    it "指定された場合だけ画像を許可し、ブロックリストは維持すること" do
      expect(route_for(url: "https://example.com/a.png", resource_type: "image",
                       allow_images: true)).to have_received(:fallback)
      expect(route_for(url: "https://yads.c.yimg.jp/a.png", resource_type: "image",
                       allow_images: true)).to have_received(:abort)
    end

    it "既定ではスクリプトをブロックしないこと" do
      expect(route_for(url: "https://example.com/app.js", resource_type: "script")).to have_received(:fallback)
    end

    it "block_scripts: true ではスクリプトをブロックすること" do
      expect(route_for(url: "https://example.com/app.js", resource_type: "script",
                       block_scripts: true)).to have_received(:abort)
    end

    it "block_scripts: true でも document はブロックしないこと" do
      expect(route_for(url: "https://example.com/", resource_type: "document",
                       block_scripts: true)).to have_received(:fallback)
    end

    it "user_agent を指定すると、そのユーザーエージェントでコンテキストを作ること" do
      route_for(url: "https://example.com/", resource_type: "document", user_agent: "custom-agent")

      expect(browser).to have_received(:new_context).with(hash_including(userAgent: "custom-agent"))
    end

    it "動的プロキシを設定したコンテキストで接続すること" do
      route_for(url: "https://example.com/", resource_type: "document")

      expect(browser).to have_received(:new_context).with(hash_including(proxy:))
    end

    it "動的プロキシが無いときは接続せずに失敗すること" do
      allow(Crawl::DynamicProxy).to receive(:get).and_return(nil)

      expect { described_class.execute { nil } }.to raise_error(Crawl::DynamicProxy::Unavailable)
      expect(browser).not_to have_received(:new_context)
    end

    it "ブロックリストにある URL はブロックすること" do
      expect(route_for(url: "https://analytics.tiktok.com/i18n/pixel/events.js",
                       resource_type: "script")).to have_received(:abort)
    end

    it "指定したホストのスクリプトだけを許可すること" do
      host = "paypayfleamarket.c.yimg.jp"
      expect(route_for(url: "https://#{host}/app.js", resource_type: "script",
                       allow_script_host: host)).to have_received(:fallback)
      expect(route_for(url: "https://#{host}/image.png", resource_type: "image",
                       allow_script_host: host)).to have_received(:abort)
      expect(route_for(url: "https://evil.example/#{host}/app.js", resource_type: "script",
                       allow_script_host: host)).to have_received(:abort)
    end
  end
end
