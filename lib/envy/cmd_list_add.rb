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

      list = ctx.smart_get(ename).interactive_to_list(ctx)

      @values.each do |val|
        evalue = ctx.expand_value(val)
        list.interative_insert_item(ctx, evalue, @pos)
      end

      ctx.set(ename, list)
    end
  end
end
