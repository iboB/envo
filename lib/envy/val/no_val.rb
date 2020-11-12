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
    def to_s
      ''
    end
    def pretty_print(ctx)
      ctx.puts '<empty>'
    end
  end
end
