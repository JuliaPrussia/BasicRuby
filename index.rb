class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains =[]
  end

  def add_train(train)
      @trains.push(train)
  end

   def delete_train(train)
     @trains.delete(train)
   end

   def all_train_type(type)
     trains_type = []
     @trains.each{|train| trains_type.push(train) if train.type == type}
     return trains_type
   end

   def all_train
     @trains
   end
end

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
end

class Train
  attr_reader :num,
              :type,
              :route,
              :train_cars,
              :speed

  def initialize(num, type, train_cars)
    @num = num
    @type = type
    @train_cars = train_cars
    @speed = 0
  end
# cкорость
  def increase_speed(speed)
    @speed += speed
  end

  def decrease_speed(value)
    @speed -= value if @speed - value >= 0
  end

  def stop
    @speed = 0
  end
#вагоны
  def add_train_cars
      @train_cars += 1 if @speed == 0
  end

  def remove_train_cars
      @train_cars -= 1 if @speed == 0 && @train_cars > 0
  end

  def all_train_cars
    @train_cars
  end
  #маршрут
  def accept_route(route)
    @route = route
    @current_station = 0
    self.current_station.add_train(self)
  end

  def go_next_station
    if next_station
      self.current_station.delete_train(self)
      @current_station += 1
      self.current_station.add_train(self)
    end
  end

  def go_prev_station
    if prev_station
      self.current_station.delete_train(self)
      @current_station -= 1
      self.current_station.add_train(self)
    end
  end

  def next_station
    return @route.stations[@current_station + 1] unless @current_station == @route.stations.length - 1
  end

  def prev_station
    return @route.stations[@current_station - 1] unless @current_station == 0
  end

  def current_station
    @route.stations[@current_station]
  end
end
