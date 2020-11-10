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
      new_val = ctx.expand_value(@value)

      old_val = ctx.smart_get(ename)

      error = new_val.type != new_val.type
      error &&= !new_val.accept_assign?(new_val)
      error &&= ctx.ask("Assign #{new_val.type} to #{new_val.type}?")
      raise Envy::Error.new "set: assignment of #{new_val.type} to #{@val.type}" if error

      error = new_val.invalid_description
      error &&= ctx.ask("Assign #{error} to #{ename}?")
      raise Envy::Error.new "set: assigniment of #{error} to #{ename}" if error

      ctx.smart_set(ename, new_val)
    end
  end
end
