require_relative 'modules/instance_counter'

class Station
  attr_reader :name,
              :trains

  include InstanceCounter

  @@stations = []
  NAME_TEMPLATE = /^[A-zА-я\d]{3,16}$/

  class << self
    def all
      @@stations
    end
  end

  def initialize(name)
    @name = name
    validate!
    @trains =[]
    @@stations.push(self)
    register_instance
  end

  def add_train(train)
      @trains.push(train)
  end

   def delete_train(train)
     @trains.delete(train)
   end

   def all_train_type(type)
     @trains.select{|train| train.type == type}
   end

   protected

   def validate!
     raise "Неправильное имя!" unless @name =~ NAME_TEMPLATE
   end

end
