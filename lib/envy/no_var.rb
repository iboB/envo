module Envy
  class NoVar
    def initialize(name)
      @name = name
    end

    attr_accessor :name
  end
end
