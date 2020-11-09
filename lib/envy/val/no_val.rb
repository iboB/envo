module Envy
  class NoVal
    def initialize(sys)
      @sys = sys
    end
    def value
      nil
    end

    # casts
    def accept_assign?(other)
      true
    end

  end
end
