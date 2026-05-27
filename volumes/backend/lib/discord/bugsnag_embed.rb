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

    def initialize(report:)
      @report = report
      @exception = report.exceptions&.first
    end

    def call
      build
    end

    private

    attr_reader :report, :exception

    def build
      {
        title: error_class,
        color: color,
        description: error_message,
        fields: fields,
        footer: footer,
        timestamp: Time.current.iso8601
      }
    end

    def fields
      list = [
        { name: "RELEASE STAGE", value: field(release_stage), inline: true },
        { name: "SEVERITY", value: field(severity_status), inline: true }
      ]
      list << { name: "Context", value: field(context), inline: false } if context.present?

      stack = stack_line
      list << { name: "STACKTRACE", value: "```\n#{stack}\n```", inline: false } if stack.present?
      list
    end

    def footer
      { text: "BugSnag · #{release_stage}" }
    end

    def color
      hex = if report.unhandled && severity == "error"
              UNHANDLED_ERROR_COLOR
            else
              SEVERITY_COLORS.fetch(severity, DEFAULT_COLOR)
            end
      self.class.hex_color(hex)
    end

    def error_class
      val(:errorClass) || "Error"
    end

    def error_message
      val(:message).presence || "-"
    end

    def severity
      report.severity.presence || "error"
    end

    def severity_status
      label = report.unhandled ? "unhandled" : "handled"
      "[#{severity}] #{label}"
    end

    def context
      report.context
    end

    def release_stage
      report.release_stage.presence || Rails.env
    end

    def field(text)
      "`#{text}`"
    end

    def stack_line
      frame = Array(exception&.dig(:stacktrace)).first
      return if frame.blank?

      file = frame[:file] || frame["file"]
      line = frame[:lineNumber] || frame["lineNumber"]
      method_name = frame[:method] || frame["method"]
      "#{file}:#{line} in #{method_name}"
    end

    def val(key)
      return if exception.blank?

      exception[key] || exception[key.to_s]
    end
  end
end
