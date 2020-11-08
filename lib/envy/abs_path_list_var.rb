module Envy
  class AbsPathListVar < ListVar
    def initialize(sys, name, ar)
      super(sys.platform, name, ar)
      @sys = sys
    end
    def attribs(elem)
      super + (@sys.path_exists?(elem) ? ' ' : 'N')
    end
  end
end
