class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains ={}
  end

  def add_train(train)
    unless @trains.include?train.type
      @trains[train.type] = []
    end
      @trains[train.type].push(train)
      puts "Прибыл поезд #{train.type} #{train.num}"
  end

   def delete_train(train)
     @trains[train.type].delete(train)
   end

   def print_type_train(type)
     puts "Список #{type} поездов:"
     @trains[type].each{|train| puts train.num}
   end

   def print_all_train
     puts "Список всех поездов на станции:"
     #При получение массива значений(@trains.values)Почему то становится не доступен
     #метод ".num". Не очень понимаю, почему.
     # @trains.values.each{|i| puts i.num}
     @trains.keys.each{ |type| @trains[type].each { |train| puts train.num}}
   end
end

class Route
  attr_accessor :stations

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
  def all_station
    @stations.each{|station| puts station}
  end
end

class Train
  attr_reader :num
              :type
              :route
              :train_cars
              :speed
              :current_station

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
    return @train_cars
  end
  #маршрут
  def accept_route(route)
    @route = route.stations
    @current_station = 0
  end

  def go_next_station
    @current_station += 1 if @current_station < @route.length - 1
  end

  def go_prev_station
    @current_station -= 1 if @current_station > 0
  end

  def next_station
     if @current_station == @route.length - 1
      puts "Это последняя станция"
    else
      next_station = @route[@current_station + 1]
      puts "Следущая станция: #{next_station}"
    end
  end

  def prev_station
    if @current_station == 0
      puts "Это первая станция"
    else
      prev_station = @route[@current_station - 1]
      puts "Предыдущая станция: #{prev_station}"
    end
  end
end
