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
          work_with_carriages
        when 6
          add_carriage_train
        when 7
          remove_carriage_train
        when 8
          move_train
        when 9
          list_stations_and_trains
        when 10
          list_trains_on_station
        when 11
          list_carriages_on_train
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
    puts '5.Создать вагон и изменять его'
    puts '6.Добавить вагоны к поезду'
    puts '7.Отцепить вагоны от поезда'
    puts '8.Переместить поезд по маршруту'
    puts '9.Просмотреть список станций и список поездов на станции'
    puts '10. Вывести список всех поездов на заданной станции'
    puts '11. Вывести список вагонов заданного поезд'
    puts '0.Выйти из меню'
  end

  def menu_choice
  end

  def new_station
    puts 'Введите имя станции(Может содержать буквы кирилического и латинского алфавита, а так же цифры. Длина 3-16 символов):'
    station_name = gets.chomp
    station = Station.new(station_name)
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

        route = Route.new(start_station, end_station)
        @route[route_name] = route
        puts "был создан маршрут #{route_name} с начальной станцией #{start_station.name} и конечной #{end_station.name}"

      when 2
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        return if name == nil
        route = @route[name]

        puts 'Введите имя станции которую желаете добавить к маршруту:'
        name_station = search_station
        return if name_station == nil

        route.add_station(name_station)
        puts "к маршруту #{name} была добавлена станция #{name_station.name}"

      when 3
        puts 'Введите имя измняемого маршрута:'
        name = name_route
        return if name == nil
        route = @route[name]

        puts 'Введите имя станции которую желаете удалить из маршрута:'
        name_station = search_station
        return if name_station == nil

        route.delete_station(name_station)
        puts "из маршрута #{name} была удалена станция #{name_station.name}"

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
      start_station = @stations.find { |station| station.name == start_station_name}
      if start_station == nil
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

  def work_with_carriages
    carriage_menu

    input = gets.chomp.to_i
    case input
    when 1
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
        puts 'Введит кол-во поссадочных мест:'
        seats = gets.chomp.to_i

        if seats <= 0
          puts "Кол-во мест не может быть меньше или равно 0!"
          return
        end

        сarriage = PassangerCarriage.new(num, seats)
        puts "Был создан вагон типа #{type} с номером #{num}. Кол-во посадочных мест: #{seats}"
        @carriages.push(сarriage)

      when 'cargo'
        puts 'Введите объем вагона:'
        capacity = gets.chomp.to_i

        if capacity <= 0
          puts "Объем не может быть меньше или равен 0!"
          return
        end

        сarriage = CargoCarriage.new(num, capacity)
        puts "Был создан вагон типа #{type} с номером #{num} и объемом #{capacity}"
        @carriages.push(сarriage)
      end

    when 2
      puts "Введите номер вагона:"
      carriage = search_carriage
      return if carriage == nil

      if carriage.type != "passanger"
        puts "Данный вагон не является пассажирским!"
        return
      end

      passanger_carriage_menu

      input = gets.chomp.to_i
      case input
      when 1
        carriage.takes_up_space
        puts "Посадочное место было успешно занято"

      when 2
        puts "Колличество свободных мест равно #{carriage.all_free_space}"

      when 3
        puts "Колличество занятых мест равно #{carriage.all_occupied_space}"
      end

    when 3
      puts "Введите номер вагона:"
      carriage = search_carriage
      return if carriage == nil

      if carriage.type != "cargo"
        puts "Данный вагон не является грузовым!"
        return
      end

      cargo_carriage_menu

      input = gets.chomp.to_i
      case input
      when 1
        puts "Введите объем который желаете занять"
        capacity = gets.chomp.to_i

        carriage.takes_up_space(capacity)

      when 2
        puts "Колличество свободного объема равно #{carriage.all_free_space}"

      when 3
        puts "Колличество занятого объема равно #{carriage.all_occupied_space}"
      end

    end
  end

  def carriage_menu
    puts "Выберите желаемое действие"
    puts "1. Создать вагон"
    puts "2. Работа с пассажирским вагоном"
    puts "3. Работа с грузовым вагоном"
  end

  def passanger_carriage_menu
    puts "1. Занять свободное место"
    puts "2. Показать колл-во свободных мест в пассажирском вагоне"
    puts "3. Показать кол-во занятых мест в пассажирском вагоне"
  end

  def cargo_carriage_menu
    puts "1. Занять объем в грузовом вагоне"
    puts "2. Показать кол-во свободного обема в грузовом вагоне"
    puts "3. Показать кол-во занятого объема в грузовом вагоне"
  end

  def add_carriage_train
    puts 'введите номер поезда:'
    train = search_train
    return if train == nil

    puts 'Введите номер вагона:'
    carriage = search_carriage
    return if carriage == nil

    train[0].add_train_cars(carriage)
    puts "Поезду #{train[0].num} был добавлен вагон #{carriage.num}"
  end

  def search_carriage
    num = gets.chomp
    while num == "" do
      puts "Номер не может быть пустым! Введите корректнный номер"
      num = gets.chomp
    end
    carriage = @carriages.find{|carriage| carriage.num == num}
    if carriage == nil
      puts "Такой вагон не найден!"
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

    train[0].remove_train_cars(carriage)
    puts "у поезда #{train[0].num} был удален вагон #{carriage.num}"
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
      puts "Поезда на станции #{station.name}:"
      station.trains.each{|train| puts train.num}
    end
  end

  def list_trains_on_station
    puts "Введите имя станции:"
    station = search_station
    return if station == nil

    station.trains_in_block {|tr| puts tr.name }
  end

  def list_carriages_on_train
    puts "Введите номер поезда:"
    train = search_train
    return if train == nil

    train.cars_in_block {|cr| puts cr.name }
  end

end
