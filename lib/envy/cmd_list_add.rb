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
      evalues = @values.map { |val| ctx.expand_value(@val) }

      list = ctx.smart_get(ename)
      if !list.list?
        if ctx.ask("#{ename} is not a list, but a #{list.type}. Convert?")
          list = list.to_envy_list
        else
          raise Envy::Error.new "Adding list item to a non-list"
        end
      end

      evalues.each do |val|
        if !list.accept_item?(val)
          if ctx.ask("Add #{val.type} to #{list.type}?")
            list.insert(val, @pos)
          else
            raise Envy::Error.new "Can't add #{val.type} to #{list.type}?"
          end
        else
          list.insert(val, @pos)
        end
      end

      ctx.set(ename, list)
    end
  end
end
