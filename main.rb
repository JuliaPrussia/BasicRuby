require_relative 'Train'
require_relative 'Station'
require_relative 'Route'
require_relative 'Carriage'
require_relative 'PassangerTrain'
require_relative 'CargoTrain'
require_relative 'PassangerCarriage'
require_relative 'CargoCarriage'
require_relative 'Interface'

#модули
require_relative 'modules/manufacturerCompany.rb'
require_relative 'modules/instanceCounter.rb'

interface = Interface.new
interface.start
