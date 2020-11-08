module Envy
  class NoVar
    def initialize(sys, name)
      @sys = sys
      @name = name
    end
    attr_accessor :name
    def to_env_val
      nil
    end
    def value
      nil
    end
    def clean!
    end

    def pretty_print(io)
      io.puts "No environment variable '#{name}'"
    end
    def interactive_to_list(io)
      io.puts "Creating a new list"
      return ListVar.new(@sys, @name, [])
    end
  end
end
