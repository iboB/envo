module Envy
  class Var
    def initialize(sys, name, val)
      @name = name
      @val = val
    end

    attr_accessor :name, :val

    def ineractive_assign(ctx, new_value)
      error = @val.type != new_value.type
      error &&= !@val.accept_assign?(new_value.type)
      error &&= ctx.ask("Assign #{new_value.type} to #{@val.type}?")

      raise Envy::Error.new "Assignment of #{new_value.type} to #{@val.type}" if error

      @val = value
    end

    def interactive_insert_item(ctx, item, pos)
      error = @val.list?
      error &&= ctx.ask("#{@name} is not a list, but a #{@val.type}. Convert?")
      raise Envy::Error.new "Adding list item to a non-list" if error

      @val = @val.to_list

      error = @val.accept_item?()
    end
  end
end
