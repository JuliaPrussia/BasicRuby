module Validate
  def valid?
    validate!
    true
  rescue
    false
  end
end
