module Envy
  class StringVar
    def initialize(name, value)
      @name = name
      @value = value
    end
    attr_accessor :name, :value
    def to_env_val
      @value
    end
  end
end
