class PassangerCarriage < Carriage
  attr_reader :seats

  def initialize(num, space)
    @type = "passanger"
    super
  end

  def takes_up_space(occupied = 1)
    super
  end

  protected
  def validate!
    super
    raise "Неверный формат!Информация о кол-ве посадочных мест задается целым чилом!" unless @seats.kind_of?(Integer)
  end
end
