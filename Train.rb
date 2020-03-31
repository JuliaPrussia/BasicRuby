class Train
  attr_reader :num,
              :type,
              :route,
              :train_cars,
              :speed

  def initialize(num, type)
    @num = num
    @type = type
    @train_cars = []
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
  def add_train_cars(carriage)
      @train_cars.push(carriage) if @speed == 0 && carriage.type == @type
  end

  def remove_train_cars(carriage)
      @train_cars.delete(carriage) if @speed == 0 && @train_cars.length > 0 && carriage.type == @type
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

  def current_station
    @route.stations[@current_station]
  end

  private
  # вспомагательные методы класса. Для передвижения по станция используются методы выше
  def next_station
    @route.stations[@current_station + 1] unless current_station == @route.last_station
  end

  def prev_station
    @route.stations[@current_station - 1] unless current_station == @route.first_station
  end
end
