module Envy
  class StringVar
    def initialize(name, value)
      @name = name
      @value = value
    end

    attr_accessor :name, :value
  end
end
