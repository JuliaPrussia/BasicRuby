class CargoTrain < Train
  def initialize(num)
    super
    @type = "cargo"
  end

  def add_train_cars(carriage)
    if carriage.type == @type
      super
    end
  end
  
end
