module instanceCounter

  def self.included(receiver)
    receiver.extend         classMethods
    receiver.send :include, instanceMethods
  end
  
  module classMethods
    def instances_count
      @instances ||= 0
      @instances += 1
    end

  def instances
      @instances
   end
  end

  module instanceMethods

    private
    def register_instance
      self.class.instances_count
    end
  end
end
