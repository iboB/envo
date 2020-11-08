module Envy
  class StringVar
    def initialize(sys, name, value)
      @sys = sys
      @name = name
      @value = value
    end
    attr_accessor :name, :value
    def to_env_val
      @value
    end
    def pretty_print(io)
      io.puts "#{name}=#{value}"
    end

    def interactive_to_list(io)
      io.puts "Converting to list"
      return ListVar.new(@sys, @name, [@value])
    end
  end
end
