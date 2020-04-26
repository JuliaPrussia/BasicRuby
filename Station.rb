class Station
  attr_reader :name,
              :trains

  def initialize(name)
    @name = name
    @trains =[]
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
     @trains
   end
end
