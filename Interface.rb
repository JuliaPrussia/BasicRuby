#Изначально думала разбить все это на несколько классов. Вопрос в том что нужно ли это?
#И если да, то как это будет выглядеть? В пунктах выбора создаем объект класса и вызываем метод?
#Что то типо :
# when 1
#   new_station = КлассОписывающийДейсвтия.new
#   new_station.метод_запуска
#И не будет ли это огромной мешаниной файлов? Может имеет смысл создать отдельную директорию?

class Interface
  def initialize
    @stations = []
    @trains = []
    @route = {}
    @carriages = []
  end

  def start
    loop do
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
  end

  def new_station
    puts 'Введите имя станции:'
    station_name = gets.chomp
    station = Station.new(station_name)
    @stations.push(station)
    puts "Станция #{station_name} была создана"
  end

  def new_train
    type = nil
    loop do
      puts 'Введите тип поезда(passanger/cargo)'
      type = gets.chomp
      if type != 'passanger' && type != 'cargo'
        puts 'Такой тип поезда не найден, повторите попытку'
      else
        break
      end
    end

    puts 'Введите номер поезда:'
    num = gets.chomp.to_i

    case type
    when 'passanger'
      train = PassengerTrain.new(num)
      puts "Был создан поезд типа #{type} с номером #{num}"
      @trains.push(train)
    when 'cargo'
      train = CargoTrain.new(num)
      puts "Был создан поезд типа #{type} с номером #{num}"
      @trains.push(train)
    end
  end

  def new_route
    loop do
      puts 'Выберите желаемое действие(введите цифру от 1-4):'
      puts '1 - Создать маршрут'
      puts '2 - Добавить промежуточных станций в маршрут'
      puts '3 - Удалить станцию из маршрута'
      puts '4 - вернуться в меню'

      input = gets.chomp.to_i

      case input
      when 1
        puts 'Введите желаемое имя маршрута(необходим для более удобного поиска)'
        route_name = gets.chomp

        loop do
          puts 'Введите имя начальной станции(или exit для выхода):'
            start_station_name = gets.chomp
            start_station = @stations.select{|station| station.name == start_station_name}

            if start_station_name == "exit"
              break
            elsif start_station.empty?
              puts "Станция не обнаружена. Пожалуйста, сначал создайте станцию с именем #{start_station_name}"
            else
              loop do
                puts 'Введите имя конечной станции(или exit для выхода):'
                  end_station_name = gets.chomp
                  end_station = @stations.select{|station| station.name == end_station_name}
                  if end_station_name == 'exit'
                    break
                  elsif end_station.empty?
                    puts "Станция не обнаружена. Пожалуйста, сначал создайте станцию с именем #{end_station_name}"
                  else
                    route = Route.new(start_station[0], end_station[0]) #принимаем за данность что имена уникальные. При необходимости, думаю, можно сделать проверку на уникальность
                    @route[route_name] = route
                    puts "был создан маршрут #{route_name} с начальной станцией #{start_station[0].name} и конечной #{end_station[0].name}"
                    break
                  end
              end
              break
            end
        end

      when 2
        loop do
          puts 'Введите имя измняемого маршрута(или exit для выхода):'
          route_name = gets.chomp
          if route_name == 'exit'
            break
          elsif @route.keys.select{|name| name == route_name}.empty?
            puts "Маршрут #{route_name} не найден. Пожалуйста, сначала создайте маршрут"
          else
            route = @route[route_name]
            loop do
              puts 'Введите имя станции которую желаете добавить к маршруту(или exit для выхода):'
                middle_station_name = gets.chomp
                middle_station = @stations.select{|station| station.name == middle_station_name}
                if middle_station_name == 'exit'
                  break
                elsif middle_station.empty?
                  puts "Станция не обнаружена. Пожалуйста, сначал создайте станцию с именем #{middle_station_name}"
                else
                  route.add_station(middle_station[0])
                  puts "к маршруту #{route_name} была добавлена станция #{middle_station[0].name}"
                  break
                end
            end
            break
          end
        end


      when 3
        loop do
          puts 'Введите имя измняемого маршрута(или exit для выхода):'
          route_name = gets.chomp
          if route_name == 'exit'
            break
          elsif @route.keys.select{|name| name == route_name}.empty?
            puts "Маршрут #{route_name} не найден. Пожалуйста, сначала создайте маршрут"
          else
            route = @route[route_name]
            loop do
              puts 'Введите имя станции которую желаете удалить из маршрута(или exit для выхода):'
                remove_station_name = gets.chomp
                remove_station = @stations.select{|station| station.name == remove_station_name}
                if remove_station_name == 'exit'
                  break
                elsif remove_station.empty?
                  puts "Станция не обнаружена."
                else
                  route.delete_station(remove_station[0])
                  puts "из маршрута #{route_name} была удалена станция #{remove_station[0].name}"
                  break
                end
            end
            break
          end
        end
      when 4
        break
      else
        puts 'Некорректный ввод. Введите значени от 1 до 4'
      end
    end
  end

  def set_train_route
    loop do
      puts 'введите номер поезда(или exit для выхода):'
      train_num = gets.chomp.to_i
      train = @trains.select{|train| train.num == train_num}
      if train_num == 'exit'
        break
      elsif train.empty?
        puts 'Данный поезд не найден'
      else
        loop do
          puts 'Введите имя добавляемого маршрута(или exit для выхода):'
          route_name = gets.chomp
          if route_name == 'exit'
            break
          elsif @route.keys.select{|name| name == route_name}.empty?
            puts "Маршрут #{route_name} не найден. Пожалуйста, сначала создайте маршрут"
          else
            train[0].accept_route(@route[route_name])
            puts "Поезду #{train[0].num} #{train[0].type} был добавлен маршрут #{route_name}"
            break
          end
        end
        break
      end
    end
  end

  def new_carriage
    type = nil

    loop do
      puts 'Введите тип вагона(passanger/cargo)'
      type = gets.chomp
      if type != 'passanger' && type != 'cargo'
        puts 'Такой тип вагона не найден, повторите попытку'
      else
        break
      end
    end

    puts 'Введите номер вагона:'
    num = gets.chomp.to_i

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
    loop do
      puts 'введите номер поезда(или exit для выхода):'
      train_num = gets.chomp
      train = @trains.select{|train| train.num == train_num.to_i}
      if train_num == 'exit'
        break
      elsif train.empty?
        puts 'Данный поезд не найден'
      else
        loop do
          puts 'Введите номер вагона(или exit для выхода):'
          num = gets.chomp
          carriage = @carriages.select{|carriage| carriage.num == num.to_i}
          if num == 'exit'
            break
          elsif carriage.empty?
            puts 'Такой вагон не найден, повторите попытку'
          elsif carriage[0].type != train[0].type
            puts "вагон типа #{carriage[0].type} нельзя прицепить к поезду типа #{train[0].type}"
          else
            train[0].add_train_cars(carriage[0])
            puts "Поезду #{train[0].num} был добавлен вагон #{carriage[0].num}"
            break
          end
        end
        break
      end
    end
  end

  def remove_carriage_train
    loop do
      puts 'введите номер поезда(или exit для выхода):'
      train_num = gets.chomp
      train = @trains.select{|train| train.num == train_num.to_i}
      if train_num == 'exit'
        break
      elsif train.empty?
        puts 'Данный поезд не найден'
      else
        loop do
          puts 'Введите номер вагона(или exit для выхода):'
          num = gets.chomp
          carriage = @carriages.select{|carriage| carriage.num == num.to_i}
          if num == 'exit'
            break
          elsif carriage.empty?
            puts 'Такой вагон не найден, повторите попытку'
          else
            train[0].remove_train_cars(carriage[0])
            puts "у поезда #{train[0].num} был удален вагон #{carriage[0].num}"
            break
          end
        end
        break
      end
    end
  end

  def move_train
    loop do
      puts 'введите номер поезда(или exit для выхода):'
      train_num = gets.chomp
      train = @trains.select{|train| train.num == train_num.to_i}
      if train_num == 'exit'
        break
      elsif train.empty?
        puts 'Данный поезд не найден'
      else
        train[0].go_next_station
        puts "поезд находится на станции #{train[0].current_station.name}"
        break
      end
    end
  end

  def list_stations_and_trains
    #Просмотреть список станций и список поездов на станции
    puts 'Список станций: '
    @stations.each{|station| puts station.name}
    loop do
      puts 'Список поездов какой станции вы хотите узнать?(exit для выхода) '
      station_name = gets.chomp
      station = @stations.select{|station| station.name == station_name}
      if station_name == 'exit'
        break
      elsif station.empty?
        puts 'Такая станция не найдена'
      else
        puts "Поезда на станции #{station[0].name}:"
        station[0].trains.each{|train| puts train.num}
        break
      end
    end
  end
end
