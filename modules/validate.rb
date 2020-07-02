module Validation

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(name, type, arg = "")
      self.validations ||= []
      rule = { type => { name: name, arg: arg } }
      validations << rule
    end
  end


  module InstanceMethods

    def validate!
      self.class.validations.each do |rule|
        rule.each do |type, params|
          value = get_instance_var_by_name(params[:name])
          send(type, value, params[:arg])
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def presence(value, arg)
      raise "Значение не должно быть пустым" if value.nil? || value.empty?
    end

    def format(value, format)
      raise "Значение не соответствует формату" if value !~ format
    end

    def type(value, attribute_class)
      raise "Объект не соответствует классу" unless attribute_class.include? value
    end

    def get_instance_var_by_name(name)
      var_name = "@#{name}".to_s
      instance_variable_get(var_name)
    end
  end


end
