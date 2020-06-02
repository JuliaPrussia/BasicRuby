class Interface
  TRAIN_TYPES = {
                :cargo     => CargoTrain,
                :passenger => PassengerTrain
              }

  def initialize
    @stations = []
    @trains = []
    @route = {}
    @carriages = []
  end

  def start
    loop do
      menu

      select = gets.chomp.to_i
      case select
        when 1
          new_station
        when 2
          new_train
        when 3
          new_route
        when 4
          set_train_route
        when 5
          new_carriage
        when 6
          add_carriage_train
        when 7
          remove_carriage_train
        when 8
          move_train
        when 9
          list_stations_and_trains
        when 0
          break
        else
          puts 'Нужно ввести число от 0 до 9 для выбора пункта меню'
        end
      end

    rescue StandardError => e
      puts"#{e.message}"
      puts "попробуйте еще раз"
    retry
  end

  private #методы ниже не предназначены для вызова из вне

  def menu
    puts 'Введите число от 0 до 9 для выбора одного из пунктов меню:'
    puts '1.Cоздать станцию'
    puts '2.Создать поезд'
    puts '3.Создать маршрут и управлять станциями в нём (добавлять, удалять)'
    puts '4.Назначить маршрут поезду'
    puts '5.Создать вагон'
    puts '6.Добавить вагоны к поезду'
    puts '7.Отцепить вагоны от поезда'
    puts '8.Переместить поезд по маршруту'
    puts '9.Просмотреть список станций и список поездов на станции'
    puts '0.Выйти из меню'
  end

  def menu_choice
  end

  def new_station
    puts 'Введите имя станции(Может содержать буквы кирилического и латинского алфавита, а так же цифры. Длина 3-16 символов):'
    station_name = gets.chomp
    @stations.push(Station.new(station_name))
    puts "Станция #{station_name} была создана"
  end

  def new_train
    puts 'Введите тип поезда(passanger/cargo)'
    type = gets.chomp.to_sym
    raise "Такого типа поезда нет" unless type == :passanger || type == :cargo

    puts 'Введите номер поезда(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра):'
    num = gets.chomp

    train_class = TRAIN_TYPES[type]
    @trains.push(train_class.new(num))
    puts "Был создан поезд типа #{type} с номером #{num}"
  end

  def new_route
    loop do
      new_route_menu

      input = gets.chomp.to_i
      case input
      when 1
        puts 'Введите желаемое имя маршрута(необходим для более удобного поиска)'
        route_name = gets.chomp
        raise "Имя маршрута не может быть пустым!" if route_name == ""

        puts 'Введите имя начальной станции:'
        start_station = search_station
        puts 'Введите имя конечной станции:'
        end_station = search_station

        unless start_station == nil || end_station == nil
          route = Route.new(start_station[0], end_station[0]) #принимаем за данность что имена уникальные. При необходимости, думаю, можно сделать проверку на уникальность
          @route[route_name] = route
          puts "был создан маршрут #{route_name} с начальной станцией #{start_station[0].name} и конечной #{end_station[0].name}"
        end

      when 2
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        route = @route[name]

        puts 'Введите имя станции которую желаете добавить к маршруту:'
        name_station = search_station

        unless name_station == nil || route == nil
          route.add_station(name_station[0])
          puts "к маршруту #{name} была добавлена станция #{name_station[0].name}"
        end

      when 3
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        route = @route[name]

        puts 'Введите имя станции которую желаете удалить из маршрута:'
        name_station = search_station

        unless name_station == nil || route == nil
          route.delete_station(name_station[0])
          puts "из маршрута #{name} была удалена станция #{name_station[0].name}"
        end

      when 4
        break
      else
        puts 'Некорректный ввод. Введите значени от 1 до 4'
      end
    end
  end

  def new_route_menu
    puts 'Выберите желаемое действие(введите цифру от 1-4):'
    puts '1 - Создать маршрут'
    puts '2 - Добавить промежуточных станций в маршрут'
    puts '3 - Удалить станцию из маршрута'
    puts '4 - вернуться в меню'
  end

  def search_station
      start_station_name = gets.chomp
      raise "Имя не может быть пустым!" if start_station_name == ""
      start_station = @stations.select{|station| station.name == start_station_name}
      raise "Станция не обнаружена. Пожалуйста, сначал создайте станцию с именем #{start_station_name}" if start_station.empty?
      return start_station
  end

  def name_route
    route_name = gets.chomp
    raise "Имя не может быть пустым!" if route_name == ""
    raise "Маршрут #{route_name} не найден. Пожалуйста, сначала создайте маршрут" if @route.keys.select{|name| name == route_name}.empty?
    return route_name
  end

  def set_train_route
    puts 'введите номер поезда:'
    train = search_train

    puts 'Введите имя добавляемого маршрута:'
    name = name_route
    route = @route[name]
    unless train == nil || name == nil
      train[0].accept_route(route)
      puts "Поезду #{train[0].num} #{train[0].type} был добавлен маршрут #{name}"
    end
  end

  def search_train
    train_num = gets.chomp
    raise "Номер не может быть пустым!" if train_num == ""
    train = @trains.select{|train| train.num == train_num}
    raise "Данный поезд не найден" if train.empty?
    return train
  end

  def new_carriage
    type = nil
    puts 'Введите тип вагона(passanger/cargo)'
    type = gets.chomp
    raise "Такой тип вагона не найден!" unless type == 'passanger' || type == 'cargo'

    puts 'Введите номер вагона(формат номера ххх, где х-строчная буква латинского алфавита или цифра):'
    num = gets.chomp

    case type
    when 'passanger'
      сarriage = PassangerCarriage.new(num)
      puts "Был создан вагон типа #{type} с номером #{num}"
      @carriages.push(сarriage)
    when 'cargo'
      сarriage = CargoCarriage.new(num)
      puts "Был создан вагон типа #{type} с номером #{num}"
      @carriages.push(сarriage)
    end
  end

  def add_carriage_train
    puts 'введите номер поезда:'
    train = search_train

    puts 'Введите номер вагона:'
    carriage = search_carriage

    unless train == nil || carriage == nil
      train[0].add_train_cars(carriage[0])
      puts "Поезду #{train[0].num} был добавлен вагон #{carriage[0].num}"
    end
  end

  def search_carriage
    num = gets.chomp
    raise "Номер не может быть пустым!" if train_num == ""
    carriage = @carriages.select{|carriage| carriage.num == num.to_i}
    raise "Такой вагон не найден!" if carriage.empty?
    return carriage
  end

  def remove_carriage_train
    puts 'введите номер поезда:'
    train = search_train

    puts 'Введите номер вагона:'
    carriage = search_carriage

    unless train == nil || carriage == nil
      train[0].remove_train_cars(carriage[0])
      puts "у поезда #{train[0].num} был удален вагон #{carriage[0].num}"
    end
  end

  def move_train
    puts 'введите номер поезда:'
    train = search_train
    unless train == nil
      train[0].go_next_station
      puts "поезд находится на станции #{train[0].current_station.name}"
    end
  end

  def list_stations_and_trains
    puts 'Список станций: '
    @stations.each{|station| puts station.name}

    puts 'Список поездов какой станции вы хотите узнать?'
    station = search_station
    unless station == nil
      puts "Поезда на станции #{station[0].name}:"
      station[0].trains.each{|train| puts train.num}
    end
  end

end
