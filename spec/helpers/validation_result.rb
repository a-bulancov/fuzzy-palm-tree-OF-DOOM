class ValidationResult
  attr_accessor :valid, :errors, :message

  def initialize(valid = true, errors = {}, message = nil)
    @valid = valid
    @errors = errors
    @message = message
  end

  def failure?
    !valid
  end
end
