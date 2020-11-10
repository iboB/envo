module Envy
  class StringVal
    def initialize(sys, str)
      @sys = sys
      @value = str
    end

    attr_reader :sys
    attr_accessor :value

    # casts
    def interactive_accept_assign?(ctx, other)
      true
    end
    def to_list
    end
  end
end
