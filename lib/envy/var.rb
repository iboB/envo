module Envy
  class Var
    def initialize(sys, name, val)
      @name = name
      @val = val
    end

    attr_accessor :name, :val
  end
end
