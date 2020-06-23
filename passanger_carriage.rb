class PassangerCarriage < Carriage
  attr_reader :seats

  def initialize(num, seats)
    @type = "passanger"
    @seats = seats
    @occupied_seats = 0
    super
  end

  def take_a_seat
    if @occupied_seats < @seats
      @occupied_seats += 1
   end
  end

  def all_occupied_seats
    @occupied_seats
  end

  def all_free_seats
    @seats - @occupied_seats
  end

  protected
  def validate!
    super
    raise "Неверный формат!Информация о кол-ве посадочных мест задается целым чилом!" unless @seats.kind_of?(Integer)
  end
end
