require "rails_helper"

# キュー名はクラス名から Crawling・Watching を除いて作る（Crawling::Mercari::Listing::SyncJob なら
# product_monitoring_mercari_listing_sync_job）。Sidekiq のダッシュボードで、キュー名からジョブを特定できるようにする
RSpec.describe "商品計測・商品モニタリングのジョブのキュー" do # rubocop:disable RSpec/DescribeClass
  let(:jobs) do
    root = Rails.root.join("app/sidekiq")
    root.glob("product_monitoring/**/*.rb").map do |path|
      path.relative_path_from(root).sub_ext("").to_s.camelize.constantize
    end
  end

  it "ジョブごとに、クラス名から作ったキュー名を使うこと" do
    jobs.each do |job|
      expected = job.name.underscore.sub(%r{/(crawling|watching)/}, "/").tr("/", "_")
      expect(job.get_sidekiq_options["queue"].to_s).to eq(expected), job.name
    end
  end

  it "すべてのキューを、docker-compose.yml で起動する Sidekiq のプロセスが処理すること" do
    queues = %w[crawl_process crawl_process_2 general_process].flat_map do |name|
      YAML.load_file(Rails.root.join("config/sidekiq/#{name}.yml"))[:queues].map(&:first)
    end
    expect(jobs.map { |job| job.get_sidekiq_options["queue"].to_s }).to all(be_in(queues))
  end
end
