require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'carriage'
require_relative 'passanger_train'
require_relative 'cargo_train'
require_relative 'passanger_carriage'
require_relative 'cargo_carriage'
require_relative 'interface'

# #модули
# require_relative 'modules/manufacturer_company.rb'
# require_relative 'modules/instance_counter.rb'

interface = Interface.new
interface.start
