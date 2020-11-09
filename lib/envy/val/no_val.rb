module Envy
  class NoVal
    def initialize(sys)
      @sys = sys
    end
    def value
      nil
    end
  end
end
