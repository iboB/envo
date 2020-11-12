module Envy
  class StringVal
    def initialize(str)
      @value = str
    end
    attr_accessor :value

    # casts
    def type
      :string
    end
    def accept_assign?(other)
      true
    end
    def invalid_description
      @value.empty? ? "empty string" : nil
    end
    def list?
      false
    end
    def to_list
      return ListVal.new([@value])
    end
    def to_s
      @value
    end
    def pretty_print(ctx)
      ctx.puts @value
      inv = invalid_description
      return if !inv
      ctx.warn "Warning: #{inv}"
    end
  end
end
