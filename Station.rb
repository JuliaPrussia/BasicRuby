class Station
  attr_reader :name,
              :trains

  @@stations = []
  def initialize(name)
    @name = name
    @trains =[]
    @@stations.push(self)
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
