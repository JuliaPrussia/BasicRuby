require_relative 'modules/manufacturer_company'
require_relative 'modules/instance_counter'

class Carriage
  include ManufacturerCompany
  include InstanceCounter

  attr_reader :num,
              :type

  def initialize(num)
    @num = num
    @type
    register_instance
  end
end
