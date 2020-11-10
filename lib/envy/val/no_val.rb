module Envy
  class NoVal
    def value
      nil
    end

    # casts
    def type
      :empty
    end
    def accept_assign?(other)
      true
    end
    def invalid_description
      nil
    end
    def list?
      false
    end
    def to_list
      return ListVal.new([])
    end
  end
end
