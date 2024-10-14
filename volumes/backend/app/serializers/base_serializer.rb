class BaseSerializer
  include ActiveModel::Serializers::JSON

  private

  def attribute_names_for_serialization
    attribute_names.map(&:to_s)
  end

  # NOTE: 継承先クラスでオーバーライドすること
  def attribute_names
    raise NotImplementedError, "#{self.class.name}##{__method__} is not defined."
  end
end
