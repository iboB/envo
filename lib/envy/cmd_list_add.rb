module Envy
  class CmdListAdd
    def self.register_help(ctx)
    end

    def self.register_cli_parser(parser)
    end

    def self.register_script_parser(parser)
    end

    def self.parse_cli(args)
    end

    def initialize(name, values, pos)
      raise Envy::Error.new 'list-add: no values to add provided' if values.empty?
      @name = name
      @values = values
      @pos = pos
    end

    attr_reader :names, :values

    def execute(ctx)
      ename = ctx.expand_name(@name)

      list = ctx.smart_get(ename)

      error = list.list?
      error &&= ctx.ask("#{@name} is not a list, but a #{list.type}. Convert?")
      raise Envy::Error.new "list-add: adding list item to a non-list" if error

      list = list.to_list

      @values.each do |val|
        val = ctx.expand_value(val)

        error = list.accept_item?(val.type)
        error &&= !ctx.ask("Add #{val.type} to #{list.type}?")
        raise Envy::Error.new "list-set: adding #{val.type} to #{list.type}" if error

        error = val.invalid_description
        error &&= !ctx.ask("Add #{error} to #{ename}?")
        raise Envy::Error.new "list-add: adding #{error} to #{ename}" if error

        list.insert(val.to_s, @pos)
      end

      ctx.smart_set(ename, list)
    end
  end
end
