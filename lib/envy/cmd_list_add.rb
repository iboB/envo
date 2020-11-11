module Envy
  class CmdListAdd
    def self.register_help(help)
      help.add_cmd(Name, "adas")
    end

    def self.register_cli_parser(parser)
      parser.add_cmd('la', ->(cmd, args) { parse_cli_all(args) })
    end

    def self.register_script_parser(parser)
    end

    def self.parse_cli_all(args)
      opts = CliParser.filter_opts_front(args)
      raise Envy::Error.new "list-add: missing name. Use 'la <name> <val>'" if args.empty?
      parse_cli_ags(args[0], args[1..], opts)
    end

    def self.parse_cli_ags(name, args, opts)
      opts += CliParser.filter_opts(args)
      pos = nil
      opts.filter! do |opt|
        case opt
        when '--front', '--top'
          pos = :front
          false
        when '--back', '--bottom'
          pos = :back
          false
        else
          true
        end
      end

      ParsedCmd.new(CmdListAdd.new(name, args, pos), opts)
    end

    def initialize(name, values, pos)
      raise Envy::Error.new 'list-add: no values to add provided' if values.empty?
      @name = name
      @values = values
      @pos = pos
    end

    attr_accessor :name, :values, :pos

    def execute(ctx)
      ename = ctx.expand_name(@name)

      list = ctx.smart_get(ename)

      ok = list.list?
      ok ||= ctx.ask("#{@name} is not a list, but a #{list.type}. Convert?")
      raise Envy::Error.new "list-add: adding list item to a non-list" if !ok

      list = list.to_list

      @values.each do |val|
        val = ctx.expand_value(val)

        ok = list.accept_item?(val.type)
        ok ||= ctx.ask("Add #{val.type} to #{list.type}?")
        raise Envy::Error.new "list-set: adding #{val.type} to #{list.type}" if !ok

        ok = !val.invalid_description
        ok ||= ctx.ask("Add #{ok} to #{ename}?")
        raise Envy::Error.new "list-add: adding #{ok} to #{ename}" if !ok

        list.insert(val.to_s, @pos)
      end

      ctx.smart_set(ename, list)
    end
  end
end
