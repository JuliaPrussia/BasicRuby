class Route
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
end
