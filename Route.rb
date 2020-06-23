require_relative 'modules/validate'

class Route
  include Validate

  attr_reader :stations

  def initialize(start, ending)
    @stations =[start, ending]
    validate!
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
    raise "Начальная и конечная станция должны отличаться!" if @stations[0] == @stations.last
    raise "Ошибка! Начальная станция не принадлежит классу 'Station'!" if @stations[0].class != Station
    raise "Ошибка! Конечная станция не принадлежит классу 'Station'!" if @stations.last.class != Station
  end
end
