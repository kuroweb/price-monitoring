require "rails_helper"

RSpec.describe Crawl::Mercari::SyncProducts::Syncer, type: :service do
  describe "#crawl_results" do
    let(:product) { instance_double(Product) }
    let(:syncer) { described_class.new(product:) }
    let(:crawl_results) { instance_double(Crawl::Mercari::SyncProducts::CrawlResults) }
    let(:crawler) { instance_double(Crawl::Mercari::SyncProducts::Crawler, execute: crawl_results) }

    before do
      allow(Crawl::Mercari::SyncProducts::Crawler).to receive(:new).with(product:).and_return(crawler)
    end

    context "Datadog が定義されていない場合" do
      before { hide_const("Datadog") if Object.const_defined?(:Datadog) }

      it "NameError にならず Crawler の戻り値を返す" do
        expect(syncer.send(:crawl_results)).to eq(crawl_results)
      end
    end

    context "Datadog::Tracing が定義されている場合" do
      let(:tracing_class) do
        Class.new do
          class << self
            def trace(_name, &)
              yield
            end
          end
        end
      end

      before do
        stub_const("Datadog", Module.new)
        stub_const("Datadog::Tracing", tracing_class)
        allow(tracing_class).to receive(:trace).and_call_original
      end

      it "trace が Syncer.crawl_results の名前で呼ばれブロックの結果を返す" do
        result = syncer.send(:crawl_results)

        expect(tracing_class).to have_received(:trace).with("Crawl::Mercari::SyncProducts::Syncer.crawl_results")
        expect(result).to eq(crawl_results)
      end
    end

    it "2 回呼んでも Crawler.new は 1 回だけである" do
      syncer.send(:crawl_results)
      syncer.send(:crawl_results)

      expect(Crawl::Mercari::SyncProducts::Crawler).to have_received(:new).once
    end
  end
end
