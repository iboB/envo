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
      if !list.list?
        if ctx.ask("#{ename} is not a list, but a #{list.type}. Convert?")
          list = list.to_list
        else
          raise Envy::Error.new "Adding list item to a non-list"
        end
      end

      @values.each do |val|
        evalue = ctx.expand_value(val)
        if list.interative_accept_item?(ctx, evalue)
          list.insert(evalue, @pos)
        else
          raise Envy::Error.new "Can't add #{evalue.type} to #{list.type}?"
        end
      end

      ctx.set(ename, list)
    end
  end
end
