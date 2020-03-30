class CargoTrain < Train
  def initialize(num, train_cars)
    super
    @type = "cargo"
  end
end
