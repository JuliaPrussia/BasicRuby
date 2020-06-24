require_relative 'modules/manufacturer_company'
require_relative 'modules/instance_counter'
require_relative 'modules/validate'

class Carriage
  include ManufacturerCompany
  include InstanceCounter
  include Validate

  attr_reader :num,
              :type

  NUM_TEMPLATE = /^[a-z\d]{3}$/

  def initialize(num, space)
    @num = num
    @type
    @space = space
    @occupied_space = 0
    validate!
    register_instance
  end

  def takes_up_space(occupied)
    if occupied <= all_free_space
      @occupied_space += occupied
    end
  end

  def all_free_space
    @space - @occupied_space
  end

  def all_occupied_space
    @occupied_space
  end

  protected

  def validate!
    raise "Неправильный формат номера!(формат номера ххх, где х-строчная буква латинского алфавита или цифра)" unless @num =~ NUM_TEMPLATE
  end

end
