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
    station = Station.new(station_name)
    raise "Неверный формат" if station.valid? == false #Имеет ли смысл выкидывать ошибку при такой валидации? просто мы можем обработать данную ошибку без падения программы.
    @stations.push(station)
    puts "Станция #{station_name} была создана"
  end

  def new_train
    puts 'Введите тип поезда(passanger/cargo)'
    type = gets.chomp.to_sym
    until type == :passanger || type == :cargo do
      puts "Такого типа поезда нет! Введите корректнный тип поезда(passanger/cargo)"
      type = gets.chomp.to_sym
    end

    puts 'Введите номер поезда(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра):'
    num = gets.chomp

    train_class = TRAIN_TYPES[type]
    train = train_class.new(num)
    raise "Неправильный формат номера!(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра)" if train.valid? == false
    @trains.push(train)
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
        while route_name == "" do
          puts "Имя маршрута не может быть пустым!"
          route_name = gets.chomp
        end

        puts 'Введите имя начальной станции:'
        start_station = search_station
        return if start_station == nil

        puts 'Введите имя конечной станции:'
        end_station = search_station
        return if end_station == nil

        route = Route.new(start_station[0], end_station[0]) #принимаем за данность что имена уникальные. При необходимости, думаю, можно сделать проверку на уникальность
        raise "Неправильный формат номера!(формат номера ххх-хх, где х-строчная буква латинского алфавита или цифра)" if route.valid? == false
        @route[route_name] = route
        puts "был создан маршрут #{route_name} с начальной станцией #{start_station[0].name} и конечной #{end_station[0].name}"

      when 2
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        return if name == nil
        route = @route[name]

        puts 'Введите имя станции которую желаете добавить к маршруту:'
        name_station = search_station
        return if name_station == nil

        route.add_station(name_station[0])
        puts "к маршруту #{name} была добавлена станция #{name_station[0].name}"

      when 3
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        return if name == nil
        route = @route[name]

        puts 'Введите имя станции которую желаете удалить из маршрута:'
        name_station = search_station
        return if name_station == nil

        route.delete_station(name_station[0])
        puts "из маршрута #{name} была удалена станция #{name_station[0].name}"

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
      while start_station_name == "" do
        puts "Имя не может быть пустым! Введите корректное значение"
        start_station_name = gets.chomp
      end
      start_station = @stations.select{|station| station.name == start_station_name}
      if start_station.empty?
        puts "Станция не обнаружена. Пожалуйста, сначал создайте станцию с именем #{start_station_name}"
        return
      else
        return start_station
      end
  end

  def name_route
    route_name = gets.chomp
    while route_name == "" do
      puts "Имя не может быть пустым! Введите корректное имя"
      route_name = gets.chomp
    end
    if @route.keys.select{|name| name == route_name}.empty?
      puts "Маршрут #{route_name} не найден. Пожалуйста, сначала создайте маршрут"
      return
    else
      return route_name
    end
  end

  def set_train_route
    puts 'введите номер поезда:'
    train = search_train
    return if train == nil

    puts 'Введите имя добавляемого маршрута:'
    name = name_route
    return if name == nil

    route = @route[name]
    train[0].accept_route(route)
    puts "Поезду #{train[0].num} #{train[0].type} был добавлен маршрут #{name}"
  end

  def search_train
    train_num = gets.chomp
    while train_num == "" do
      puts "Номер не может быть пустым! Введите корректнный номер."
      train_num = gets.chomp
    end

    train = @trains.select{|train| train.num == train_num}
    if train.empty?
      puts "Данный поезд не найден"
      return
    else
      return train
    end
  end

  def new_carriage
    puts 'Введите тип вагона(passanger/cargo)'
    type = gets.chomp
    until type == "passanger" || type == "cargo" do
      puts "Такой тип вагона не найден! Введите корректнный тип (passanger/cargo)"
      type = gets.chomp
    end

    puts 'Введите номер вагона(формат номера ххх, где х-строчная буква латинского алфавита или цифра):'
    num = gets.chomp

    case type
    when 'passanger'
      сarriage = PassangerCarriage.new(num)
      raise "Неверный формат номера!" if carriage.valid? == false
      puts "Был создан вагон типа #{type} с номером #{num}"
      @carriages.push(сarriage)
    when 'cargo'
      сarriage = CargoCarriage.new(num)
      raise "Неверный формат номера!" if carriage.valid? == false
      puts "Был создан вагон типа #{type} с номером #{num}"
      @carriages.push(сarriage)
    end
  end

  def add_carriage_train
    puts 'введите номер поезда:'
    train = search_train
    return if train == nil

    puts 'Введите номер вагона:'
    carriage = search_carriage
    return if carriage == nil

    train[0].add_train_cars(carriage[0])
    puts "Поезду #{train[0].num} был добавлен вагон #{carriage[0].num}"
  end

  def search_carriage
    num = gets.chomp
    while train_num == "" do
      puts "Номер не может быть пустым! Введите корректнный номер"
      num = gets.chomp
    end
    carriage = @carriages.select{|carriage| carriage.num == num.to_i}
    if carriage.empty?
      puts "Такой вагон не найден!" if carriage.empty?
      return
    else
      return carriage
    end
  end

  def remove_carriage_train
    puts 'введите номер поезда:'
    train = search_train
    return if train == nil

    puts 'Введите номер вагона:'
    carriage = search_carriage
    return if carriage == nil

    train[0].remove_train_cars(carriage[0])
    puts "у поезда #{train[0].num} был удален вагон #{carriage[0].num}"
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
