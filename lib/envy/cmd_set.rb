module Envy
  class CmdSet
    Name = 'set'
    def self.register_help(ctx)
      ctx.help.add_cmd(Name, "set stuff")
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_script(args) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)

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
      evalue = ctx.expand_value(@value)

      old_val = ctx.smart_get(ename)
      if old_val.ineractive_accept_assign?(ctx, evalue)
        ctx.set(ename, evalue)
      else
        raise Envy::Error.new "Assignment of #{evalue.type} to #{old_val.type}"
      end
    end
  end
end
