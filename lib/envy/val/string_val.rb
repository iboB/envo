module Envy
  class StringVal
    def initialize(str)
      @value = str
    end
    attr_reader :value
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
  end
end
