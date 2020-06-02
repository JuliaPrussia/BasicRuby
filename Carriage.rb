require_relative 'modules/manufacturer_company'
require_relative 'modules/instance_counter'

class Carriage
  include ManufacturerCompany
  include InstanceCounter

  attr_reader :num,
              :type

  NUM_TEMPLATE = /^[a-z\d]{3}$/

  def initialize(num)
    @num = num
    @type
    register_instance
  end

  protected

  def validate!
    raise "Неправильный формат номера!(формат номера ххх, где х-строчная буква латинского алфавита или цифра)" unless @num =~ NUM_TEMPLATE
  end

end
