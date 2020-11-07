module Envy
  class AbsPathVar
    def initialize(sys, name, value)
      @name = name
      @value = value
      @exist = sys.path_exists?(value)
    end
    attr_accessor :name, :value
    def to_env_val
      @value
    end
    def pretty_print(io)
      io.puts "#{name}=#{value}"
      io.puts "Warning: This path doesn't exist on the system" if !@exist
    end
    def exist?
      @exist
    end
    def <=>(other)
      self.value <=> other.value
    end
    def ==(other)
      self.value == other.value
    end
  end
end
