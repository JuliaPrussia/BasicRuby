module ManufacturerCompany
  #Если я правильно поняла, то мы храним в этом методе переменную, которую изменяем через интерфейс.
  #Ну и вызвав ее напрямую, можем узнать информацию, отдельный метод не обязателен.
  attr_accessor :company_name
  @company_name
  # def add_name
  #   @company_name = gets.chomp
  # end
  #
  # def name
  #   @company_name
  # end
end
