module Envy
  class StringVal
    def initialize(sys, str)
      @sys = sys
      @value = str
    end

    attr_reader :sys
    attr_accessor :value
  end
end
