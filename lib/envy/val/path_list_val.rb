module Envy
  class PathListVal < ListVal
    def initialize(sys, ar)
      super(ar)
    end
    def type
      :"path list"
    end
    def accept_assign?(other)
      other.type == type
    end
    def accept_item?(item)
      item.type == :path
    end
  end
end
