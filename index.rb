class Station
  attr_accessor :passenger_train

  def initialize(station_name)
    @station_name = station_name
    @cargo_train = []
    @passenger_train = []
  end

  def add_train(train)
    if train.type == "passenger"
      @passenger_train.push(train.num)
    elsif train.type == "cargo"
      @cargo_train.push(train.num)
    end
  end

  def delete_train(train)
    if train.type == "passenger"
      @passenger_train.delete(train.num)
    elsif train.type == "cargo"
      @cargo_train.delete(train.num)
    end
    puts "Со станции отбыл поезд: #{train.num}"
  end
end

class Route
  attr_accessor :route

  def initialize(start, ending)
    @route =[start, ending]
  end

  def add_station(station)
    @route.insert(-2, station)
    puts "В маршрут была добавлена станция #{station}"
  end

  def delete_station(station)
    if station == @route[0] || station == @route.last
      puts "Это начальная/конечная станция. Нельзя удалять!"
    else
      @route.delete(station)
      puts "Из маршрута удалена станция #{station}"
    end
  end
  def all_station
    puts @route
  end
end

class Train
  attr_accessor :num
  attr_accessor :type
  attr_accessor :route
  attr_accessor :current_station

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

  def speed_now
    puts "Скорость равна #{@speed}"
  end

  def stop
    @speed = 0
  end
#вагоны
  def add_train_cars
    if @speed == 0
      @train_cars += 1
    else
      puts "Остановите поезд"
    end
  end

  def remove_train_cars
    if @speed == 0
      @train_cars -= 1
    else
      puts "Остановите поезд"
    end
  end

  def all_train_cars
    puts "Сейчас вагонов: #{@train_cars}"
  end
  #маршрут
  def accept_route(route)
    @route = route.route
    self.current_station = self.route.first
    puts "Поезд находится на станции #{current_station} и будет двигаться по марщруту #{self.route.first} - #{self.route.last}"
  end

  def go_next_station
    if self.current_station == self.route.last
      puts "Это конечная станция, поезд дальше не идет"
    else
      self.current_station = self.route[self.route.index(self.current_station) + 1]
      puts "Поезд прибыл на станцию #{self.current_station}"
    end
  end

  def go_previous_station
    if self.current_station == self.route.first
      puts "Это первая станция, можно ехать только вперед"
    else
      self.current_station = self.route[self.route.index(self.current_station) - 1]
      puts "Поезд приехал на станцию #{self.current_station}"
    end
  end

  def show_next_station
     if self.current_station == self.route.last
      puts "Это последняя станция"
    else
      next_station = self.route[self.route.index(self.current_station) + 1]
      puts "Следущая станция: #{next_station}"
    end
  end

  def show_prev_station
    if self.current_station == self.route.first
      puts "Это первая станция"
    else
      prev_station = self.route[self.route.index(self.current_station) - 1]
      puts "Предыдущая станция: #{prev_station}"
    end
  end
end
