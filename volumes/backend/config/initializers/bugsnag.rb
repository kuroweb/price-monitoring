Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY", nil)
end

Rails.application.config.to_prepare do
  patch = Patches::Bugsnag::SynchronousDelivery
  singleton = Bugsnag::Delivery::Synchronous.singleton_class
  singleton.prepend(patch) unless singleton.ancestors.include?(patch)
end
