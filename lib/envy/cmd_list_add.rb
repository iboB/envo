module Envy
  class CmdListAdd
    def self.register_help(help)
      help.add_cmd 'la <name> <val>', "shorthand for 'list <name> add <val>'"
    end

    def self.register_cli_parser(parser)
      parser.add_cmd('la', ->(cmd, args) { parse_cli_all(args) })
    end

    def self.register_script_parser(parser)
    end

    def self.parse_cli_all(args)
      opts = CliParser.filter_opts_front(args)
      raise Envy::Error.new "list-add: missing name. Use 'la <name> <val>'" if args.empty?
      parse_cli_args(args[0], args[1..], opts)
    end

    def self.parse_script(name, tokens, opts)
      pos = nil
      opts.filter! do |opt|
        case opt
        when 'front', 'top'
          pos = :front
          false
        when 'back', 'bottom'
          pos = :back
          false
        else
          true
        end
      end

      ParsedCmd.new(CmdListAdd.new(name, tokens, pos), opts)
    end

    def self.parse_cli_args(name, args, opts)
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
      if !ok
        if list.type == :empty
          ok ||= ctx.ask("#{ename} doesn't exist. Create?")
        else
          ok ||= ctx.ask("#{ename} is not a list, but a #{list.type}. Convert?")
        end
      end
      raise Envy::Error.new "list-add: adding list item to a non-list" if !ok

      list = list.to_list

      ordered = @pos == :front ? values.reverse : values
      ordered.each do |val|
        val = ctx.expand_value(val)

        ok = list.accept_item?(val)
        ok ||= ctx.ask("Add #{val.type} to #{list.type}?")
        raise Envy::Error.new "list-add: adding #{val.type} to #{list.type}" if !ok

        idesc = val.invalid_description
        ok = !idesc
        ok ||= ctx.ask("Add #{idesc} to #{ename}?")
        raise Envy::Error.new "list-add: adding #{idesc} to #{ename}" if !ok

        list.insert(val.to_s, @pos)
      end

      ctx.smart_set(ename, list)
    end
  end
end
