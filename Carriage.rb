class Carriage
  include manufacturerCompany

  attr_reader :num,
              :type

  def initialize(num)
    @num = num
    @type
  end
end
