module Envy
  class NoVal
    def initialize(sys)
      @sys = sys
    end
    def value
      nil
    end

    # casts
    def interactive_accept_assign?(ctx, other)
      true
    end
    def to_list
    end
  end
end
