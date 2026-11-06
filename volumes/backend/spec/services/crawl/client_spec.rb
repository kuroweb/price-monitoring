require "rails_helper"

RSpec.describe Crawl::Client, type: :service do
  describe ".execute" do
    let(:page) { instance_double(Playwright::Page) }
    let(:context) { instance_double(Playwright::BrowserContext, new_page: page) }
    let(:browser) { instance_double(Playwright::Browser, new_context: context) }
    let(:route_handler) { {} }

    before do
      stub_const("ENV", ENV.to_h.merge("PLAYWRIGHT_URL" => "ws://playwright"))
      allow(Crawl::DynamicProxy).to receive(:get).and_return(nil)
      allow(Playwright).to receive(:connect_to_browser_server).and_yield(browser)
      allow(page).to receive(:route) { |_pattern, handler| route_handler[:call] = handler }
    end

    def route_for(url:, resource_type:, **)
      route = instance_double(Playwright::Route, abort: nil, fallback: nil)
      request = instance_double(Playwright::Request, url:, resource_type:)

      described_class.execute(**) { route_handler[:call].call(route, request) }
      route
    end

    it "画像とフォントは常にブロックする" do
      expect(route_for(url: "https://example.com/a.png", resource_type: "image")).to have_received(:abort)
      expect(route_for(url: "https://example.com/a.woff2", resource_type: "font")).to have_received(:abort)
    end

    it "既定ではスクリプトをブロックしない" do
      expect(route_for(url: "https://example.com/app.js", resource_type: "script")).to have_received(:fallback)
    end

    it "block_scripts: true ではスクリプトをブロックする" do
      expect(route_for(url: "https://example.com/app.js", resource_type: "script",
                       block_scripts: true)).to have_received(:abort)
    end

    it "block_scripts: true でも document はブロックしない" do
      expect(route_for(url: "https://example.com/", resource_type: "document",
                       block_scripts: true)).to have_received(:fallback)
    end

    it "user_agent を指定すると、そのユーザーエージェントでコンテキストを作る" do
      route_for(url: "https://example.com/", resource_type: "document", user_agent: "custom-agent")

      expect(browser).to have_received(:new_context).with(hash_including(userAgent: "custom-agent"))
    end

    it "ブロックリストにある URL はブロックする" do
      expect(route_for(url: "https://analytics.tiktok.com/i18n/pixel/events.js",
                       resource_type: "script")).to have_received(:abort)
    end
  end
end
