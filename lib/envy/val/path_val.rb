module Envy
  class PathVal
    def initialize(sys, str)
      @sys = sys
      @path = str
    end
    attr_reader :sys
    attr_accessor :path
    # casts
    def type
      :path
    end
    def accept_assign?(other)
      other.type == type
    end
    def invalid_description
      @sys.path_exists?(@path) ? nil : 'non-existing path'
    end
    def list?
      false
    end
    def to_list
      return PathListVal.new(@sys, [@path])
    end
    def to_s
      @path
    end
  end
end
