class ServiceResponse
  def self.success(message: nil, payload: {}, http_status: :ok)
    new(
      status: :success,
      message:,
      payload:,
      http_status:
    )
  end

  def self.error(message:, payload: {}, http_status: nil, reason: nil)
    new(
      status: :error,
      message:,
      payload:,
      http_status:,
      reason:
    )
  end

  attr_reader :status, :message, :http_status, :payload, :reason

  def initialize(status:, message: nil, payload: {}, http_status: nil, reason: nil)
    self.status = status
    self.message = message
    self.payload = payload
    self.http_status = http_status
    self.reason = reason
  end

  def log_and_raise_exception(as: StandardError, **_extra_data)
    error_tracking(as) do |ex|
      # TODO: ロギング処理を追加する
    end
  end

  def track_exception(as: StandardError, **_extra_data)
    error_tracking(as) do |ex|
      # TODO: ロギング処理を追加する
    end
  end

  def track_and_raise_exception(as: StandardError, **_extra_data)
    error_tracking(as) do |ex|
      # TODO: ロギング処理を追加する
    end
  end

  def [](key)
    to_h[key]
  end

  def to_h
    (payload || {}).merge(
      status:,
      message:,
      http_status:,
      reason:
    )
  end

  def deconstruct_keys(keys)
    to_h.slice(*keys)
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end

  def errors
    return [] unless error?

    Array.wrap(message)
  end

  private

  attr_writer :status, :message, :http_status, :payload, :reason

  def error_tracking(error_klass)
    if error?
      ex = error_klass.new(message)
      yield ex
    end

    self
  end
end
