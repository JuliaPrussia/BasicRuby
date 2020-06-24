class CargoCarriage < Carriage
  attr_reader :capacity

  def initialize(num, space)
    @type = "cargo"
    super
  end

  protected
  def validate!
    super
    raise "Неверный формат!Информация об объеме поезда задается числом!" unless @capacity.kind_of?(Integer) || @capacity.kind_of?(Float)
  end

end
