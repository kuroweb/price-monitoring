module ProductMonitoring
  class WatchSettingWriter
    def self.call(product_watch_setting:, params:)
      values = ProductMonitoring::Input.call(params:, require_name: true)
      attributes = values.slice(:name, :enabled, :required_keywords, :exclude_keywords, :min_price, :max_price)
      attributes[:discord_enabled] = ProductMonitoring::Input.boolean(values.fetch(:discord_enabled, false))
      write = lambda do
        product_watch_setting.assign_attributes(attributes)
        if product_watch_setting.changes.keys.intersect?(%w[enabled discord_enabled required_keywords exclude_keywords
                                                            min_price max_price])
          product_watch_setting.last_lowest_signature = nil
        end
        product_watch_setting.save!
      end
      product_watch_setting.new_record? ? write.call : product_watch_setting.with_lock(&write)
      product_watch_setting
    end
  end
end
