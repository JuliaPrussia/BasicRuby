require_relative 'modules/manufacturer_company'
require_relative 'modules/instance_counter'
require_relative 'modules/validate'

class Train
  include ManufacturerCompany
  include InstanceCounter
  include Validate

  attr_reader :num,
              :type,
              :route,
              :train_cars,
              :speed
              :trains

  @@trains = {}
  NUM_TEMPLATE = /^[a-z\d]{3}-*[a-z\d]{2}$/

  def initialize(num)
    @num = num
    @type
    @train_cars = []
    @speed = 0
    valid?
    @@trains[@num] = self
    register_instance
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
      @train_cars.push(carriage) if @speed == 0
  end

  def remove_train_cars(carriage)
      @train_cars.delete(carriage) if @speed == 0
  end

  def all_train_cars
    @train_cars
  end
#маршрут
  def accept_route(route)
    @route = route
    @current_station = 0
    current_station.add_train(self)
  end

  def go_next_station
    if next_station
      current_station.delete_train(self)
      @current_station += 1
      current_station.add_train(self)
    end
  end

  def go_prev_station
    if prev_station
      current_station.delete_train(self)
      @current_station -= 1
      current_station.add_train(self)
    end
  end

  def current_station
    @route.stations[@current_station]
  end

  def self.find(num)
    @@trains[num]
  end

  protected

  def validate!
    raise "Неправильный формат номера!(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра)" unless @num =~ NUM_TEMPLATE
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
