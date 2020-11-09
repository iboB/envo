# perhaps too little for a class?
module Envy
  class Val
    def initialize(sys)
      @sys = sys
    end

    attr_reader :sys
  end
end
