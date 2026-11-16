require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Client do
  let(:page) { instance_double(Playwright::Page) }
  let(:context) { instance_double(Playwright::BrowserContext, new_page: page) }
  let(:browser) { instance_double(Playwright::Browser, new_context: context) }
  let(:route_handler) { {} }
  let(:proxy) { { server: "proxy.example:8080", username: "user", password: "pass" } }

  before do
    stub_const("ENV", ENV.to_h.merge("PLAYWRIGHT_URL" => "ws://playwright"))
    allow(ProductMonitoring::Crawling::Proxy).to receive(:call).and_return(proxy)
    allow(Playwright).to receive(:connect_to_browser_server).and_yield(browser)
    allow(page).to receive(:route) { |_pattern, handler| route_handler[:call] = handler }
  end

  def route_for(url:, resource_type:, **)
    route = instance_double(Playwright::Route, abort: nil, fallback: nil)
    request = instance_double(Playwright::Request, url:, resource_type:)

    described_class.execute(**) { route_handler[:call].call(route, request) }
    route
  end

  it "プロキシと User-Agent を設定したコンテキストでページを開くこと" do
    route_for(url: "https://example.com/", resource_type: "document", user_agent: "custom-agent")

    expect(browser).to have_received(:new_context).with(userAgent: "custom-agent", proxy:)
  end

  it "プロキシが無いときはブラウザへ接続せずに失敗すること" do
    allow(ProductMonitoring::Crawling::Proxy).to receive(:call)
      .and_raise(ProductMonitoring::Crawling::Proxy::Unavailable)

    expect { described_class.execute { nil } }.to raise_error(ProductMonitoring::Crawling::Proxy::Unavailable)
    expect(Playwright).not_to have_received(:connect_to_browser_server)
  end

  it "画像・フォントとブロックリストの URL を止め、それ以外は読み込むこと" do
    expect(route_for(url: "https://example.com/a.png", resource_type: "image")).to have_received(:abort)
    expect(route_for(url: "https://example.com/a.woff2", resource_type: "font")).to have_received(:abort)
    expect(route_for(url: "https://analytics.tiktok.com/events.js", resource_type: "script")).to have_received(:abort)
    expect(route_for(url: "https://example.com/app.js", resource_type: "script")).to have_received(:fallback)
  end

  it "指定したときだけ画像とスクリプトの扱いを変えること" do
    expect(route_for(url: "https://example.com/a.png", resource_type: "image",
                     allow_images: true)).to have_received(:fallback)
    expect(route_for(url: "https://yads.c.yimg.jp/a.png", resource_type: "image",
                     allow_images: true)).to have_received(:abort)
    expect(route_for(url: "https://example.com/app.js", resource_type: "script",
                     block_scripts: true)).to have_received(:abort)
    expect(route_for(url: "https://example.com/", resource_type: "document",
                     block_scripts: true)).to have_received(:fallback)
  end

  it "許可したホストのスクリプトだけをブロックリストから外すこと" do
    host = "paypayfleamarket.c.yimg.jp"
    expect(route_for(url: "https://#{host}/app.js", resource_type: "script",
                     allow_script_host: host)).to have_received(:fallback)
    expect(route_for(url: "https://#{host}/app.js", resource_type: "script")).to have_received(:abort)
    expect(route_for(url: "https://#{host}/a.png", resource_type: "image",
                     allow_script_host: host)).to have_received(:abort)
    expect(route_for(url: "https://evil.example/#{host}/app.js", resource_type: "script",
                     allow_script_host: host)).to have_received(:abort)
  end
end
