require_relative 'modules/instance_counter'

class Station
  attr_reader :name,
              :trains

  include InstanceCounter

  @@stations = []
  def initialize(name)
    @name = name
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

   def all
     @@stations
   end
end
