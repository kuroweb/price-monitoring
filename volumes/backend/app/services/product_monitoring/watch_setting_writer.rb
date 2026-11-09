module ProductMonitoring
  class WatchSettingWriter
    def self.call(product_watch_setting:, params:)
      values = ProductMonitoring::Input.call(params:, require_name: true)
      attributes = values.slice(:name, :enabled, :required_keywords, :exclude_keywords, :min_price, :max_price)
      attributes[:discord_enabled] = ProductMonitoring::Input.boolean(values.fetch(:discord_enabled, false))
      write = -> { write_attributes(product_watch_setting, attributes) }
      product_watch_setting.new_record? ? write.call : product_watch_setting.with_lock(&write)
      product_watch_setting
    end

    def self.write_attributes(setting, attributes)
      setting.assign_attributes(attributes)
      filters_changed = filters_changed?(setting)
      if setting.changes.keys.intersect?(%w[enabled discord_enabled required_keywords exclude_keywords
                                            min_price max_price])
        setting.last_lowest_signature = nil
      end
      setting.save!
      setting.product_aggregation_results.delete_all if filters_changed
    end
    private_class_method :write_attributes

    def self.filters_changed?(setting)
      setting.persisted? && setting.changes.keys.intersect?(%w[required_keywords exclude_keywords min_price max_price])
    end
    private_class_method :filters_changed?
  end
end
