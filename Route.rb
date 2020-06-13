require_relative 'modules/validate'

class Route
  include Validate

  attr_reader :stations

  def initialize(start, ending)
    @stations =[start, ending]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    unless station == @stations[0] || station == @stations.last
      @stations.delete(station)
    end
  end

  def show_all_station
    @stations.each{|station| puts station}
  end

  def first_station
    @stations[0]
  end

  def last_station
    @stations[@stations.length-1]
  end

  protected

  def validate!
    raise "Неправильный формат номера!(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра)" if @num =~ NUM_TEMPLATE
  end
end
