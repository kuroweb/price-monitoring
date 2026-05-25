module Discord
  class BugsnagEmbed
    SEVERITY_COLORS = {
      "error" => "#ED4245",
      "warning" => "#FEE75C",
      "info" => "#5865F2"
    }.freeze
    DEFAULT_COLOR = "#95A5A6"
    UNHANDLED_ERROR_COLOR = "#DA373C"

    def self.call(...)
      new(...).call
    end

    def self.hex_color(value)
      value.delete("#").to_i(16)
    end

    def initialize(payload:, dashboard_url: nil)
      data = payload.is_a?(String) ? JSON.parse(payload) : payload
      @event = data["events"]&.first
      @exception = @event&.dig("exceptions", 0)
      @dashboard_url = dashboard_url
    end

    def call
      build
    end

    private

    def build
      result = {
        title: error_class,
        color: color,
        description: error_message,
        fields: fields,
        footer: footer,
        timestamp: Time.current.iso8601
      }
      result[:url] = @dashboard_url if @dashboard_url.present?
      result
    end

    def fields
      list = [
        { name: "RELEASE STAGE", value: field(Rails.env), inline: true },
        { name: "SEVERITY", value: field(severity_status), inline: true }
      ]
      list << { name: "Context", value: field(context), inline: false } if context.present?

      stack = stack_line
      list << { name: "STACKTRACE", value: "```\n#{stack}\n```", inline: false } if stack.present?
      list
    end

    def footer
      { text: "BugSnag · #{Rails.env}" }
    end

    def color
      hex = if val("unhandled", from: @event) && severity == "error"
              UNHANDLED_ERROR_COLOR
            else
              SEVERITY_COLORS.fetch(severity, DEFAULT_COLOR)
            end
      self.class.hex_color(hex)
    end

    def error_class
      val("errorClass") || "Error"
    end

    def error_message
      val("message").presence || "-"
    end

    def severity
      val("severity", from: @event).presence || "error"
    end

    def severity_status
      label = val("unhandled", from: @event) == true ? "unhandled" : "handled"
      "[#{severity}] #{label}"
    end

    def context
      val("context", from: @event)
    end

    def field(text)
      "`#{text}`"
    end

    def stack_line
      frame = Array(@exception&.dig("stacktrace")).first
      return if frame.blank?

      file = frame["file"] || frame[:file]
      line = frame["lineNumber"] || frame[:lineNumber]
      method_name = frame["method"] || frame[:method]
      "#{file}:#{line} in #{method_name}"
    end

    def val(key, from: @exception)
      return if from.blank?

      from[key] || from[key.to_sym]
    end
  end
end
