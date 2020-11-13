module Envy
  class CmdSet
    Name = 'set'
    def self.register_help(help)
      help.add_cmd "set <name>=<val>", <<~EOF
        set a value to an environment variable
        'set name=' unsets the value
      EOF
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_tokens(tokens, opts) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      parse_tokens(args, opts)
    end

    def self.parse_tokens(args, opts)
      # find first instance of equals
      i = args.find_index { |arg| arg =~ /=/ }
      raise Envy::Error.new "set: missing '='. Use 'set <name> = <val>'" if !i

      elem = args[i]
      eq_i = elem.index('=')

      first = elem[0...eq_i]
      second = elem[eq_i+1..]
      split = [first, '=', second].select { |s| !s.empty? }

      args[i..i] = split

      i = args.index('=')
      raise Envy::Error.new "set: bad name '#{args[0...i].join(' ')}'. Use 'set <name> = <val>'" if i != 1

      return ParsedCmd.new(CmdUnset.new([args[0]]), opts) if args.size == 2

      ParsedCmd.new(CmdSet.new(args[0], args[2..]), opts)
    end

    def self.parse_script(args)
      puts "#{Name} parse_script"
    end

    def initialize(name, value)
      @name = name
      @value = value
    end

    attr_accessor :name, :value

    def execute(ctx)
      ename = ctx.expand_name(@name)
      new_val = ctx.expand_value(@value)

      old_val = ctx.smart_get(ename)

      ok = old_val.type == new_val.type
      ok ||= old_val.accept_assign?(new_val)
      ok ||= ctx.ask("Assign #{new_val.type} to #{old_val.type}?")
      raise Envy::Error.new "set: assignment of #{new_val.type} to #{old_val.type}" if !ok

      idesc = new_val.invalid_description
      ok = !idesc
      ok ||= ctx.ask("Assign #{idesc} to #{ename}?")
      raise Envy::Error.new "set: assignment of #{idesc} to #{ename}" if !ok

      ctx.smart_set(ename, new_val)
    end
  end
end
