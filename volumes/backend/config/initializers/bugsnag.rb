Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY", nil)

  config.add_on_error(proc { |report| Discord::BugsnagNotifier.call(report: report) })
end
