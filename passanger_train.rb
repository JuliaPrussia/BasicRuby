class PassengerTrain < Train
  def initialize(num)
    super
    @type = 'passanger'
  end

  def add_train_cars(carriage)
    if carriage.type == @type
      super
    end
  end
end
