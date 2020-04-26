require_relative 'Modules'

class Carriage
  include ManufacturerCompany
  attr_reader :num,
              :type

  def initialize(num)
    @num = num
    @type
  end
end
