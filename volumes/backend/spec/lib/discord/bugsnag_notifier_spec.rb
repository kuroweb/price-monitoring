require "rails_helper"

RSpec.describe Discord::BugsnagEmbed do
  describe "#call" do
    it "builds an embed from a Bugsnag report" do
      report = Bugsnag::Report.new(RuntimeError.new("boom"), Bugsnag.configuration, true)
      report.context = "Api::ProductsController#show"

      embed = described_class.call(report: report)

      expect(embed[:title]).to eq("RuntimeError")
      expect(embed[:description]).to eq("boom")
      expect(embed[:fields]).to include(
        { name: "RELEASE STAGE", value: "`#{report.release_stage}`", inline: true },
        { name: "SEVERITY", value: "`[error] unhandled`", inline: true },
        { name: "Context", value: "`Api::ProductsController#show`", inline: false }
      )
      expect(embed[:fields].last[:name]).to eq("STACKTRACE")
      expect(embed[:url]).to be_nil
    end
  end
end

RSpec.describe Discord::BugsnagNotifier do
  describe "#call" do
    it "posts an embed to Discord" do
      stub_const("ENV", ENV.to_hash.merge("BUGSNAG_DISCORD_WEBHOOK_URL" => "https://discord.com/api/webhooks/1/token"))
      stub_request(:post, %r{discord\.com/api/webhooks}).to_return(status: 204)

      report = Bugsnag::Report.new(RuntimeError.new("boom"), Bugsnag.configuration, false)

      described_class.call(report: report)

      expect(a_request(:post, %r{discord\.com/api/webhooks})).to have_been_made.once
    end

    it "does not post when webhook URL is missing" do
      stub_const("ENV", ENV.to_hash.merge("BUGSNAG_DISCORD_WEBHOOK_URL" => ""))
      stub_request(:post, %r{discord\.com/api/webhooks}).to_return(status: 204)

      report = Bugsnag::Report.new(RuntimeError.new("boom"), Bugsnag.configuration, false)

      described_class.call(report: report)

      expect(a_request(:post, %r{discord\.com/api/webhooks})).not_to have_been_made
    end
  end
end
