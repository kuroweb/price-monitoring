module Api
  class BaseSerializer
    def render_json
      normalize_json
    end

    private

    # @override
    def json
      raise NotImplementedError, "#{self.class.name}##{__method__} is not defined."
    end

    def normalize_json
      json.is_a?(Hash) ? json.with_indifferent_access : json
    end
  end
end
