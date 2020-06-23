class CargoCarriage < Carriage
  attr_reader :capacity

  def initialize(num, capacity)
    @type = "cargo"
    @capacity = capacity
    @occupied_capacity = 0
    super
  end

  def takes_up_capacity(capacity)
    if @occupied_capacity < @capacity && capacity < @capacity - @occupied_capacity
      @occupied_capacity += capacity
    end
  end

  def all_free_capacity
    @capacity - @occupied_capacity
  end

  def all_occupied_capacity
    @occupied_capacity
  end

  protected
  def validate!
    super
    raise "Неверный формат!Информация об объеме поезда задается числом!" unless @capacity.kind_of?(Integer) || @capacity.kind_of?(Float)
  end

end
