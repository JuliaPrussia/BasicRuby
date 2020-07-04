module Accessors

  def self.included(receiver)
    receiver.extend         ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        history_name = "@#{name}_history".to_sym
        define_method(name) {instance_variable_get(var_name)}
        define_method("#{name}_history") {instance_variable_get(history_name)}

        define_method("#{name}=".to_sym) do |value|
          if instance_variable_get(history_name).nil?
            instance_variable_set(history_name, [instance_variable_get(var_name)])
          else
            instance_variable_get(history_name) << instance_variable_get(var_name)
          end
          instance_variable_set(var_name, value)
        end
      end
    end
  end

  def strong_attr_acessor(name, type)
    name = "@#{name}".to_sym
    define_method(name) {instance_variable_get(name)}
    define_method("@#{name}=".to_sym) do |value|
      if value.is_a?(type)
        instance_variable_set(name, value)
      else
        raise TypeError
      end
    end
  end

end
