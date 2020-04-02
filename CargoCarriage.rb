class CargoCarriage < Carriage
  def initialize(num)
    super
    @type = "cargo"
  end
end
