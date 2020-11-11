module Envy
  class CmdReset
    Name = 'reset'
    def self.register_help(ctx)
      ctx.help.add_cmd(Name, "reset stuff")
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_script(args) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)

      raise Envy::Error.new "reset: missing name. Use 'reset <name> [= [<val>]]'" if args.empty? || args[0][0] == '='
      if args.size == 1
        arg = args[0]
        cnt = arg.count('=')
        return ParsedCmd.new(CmdReset.new(arg, nil), opts) if cnt == 0
        if cnt == 1 && arg[-1] == '='
          split = arg.split('=')
          return ParsedCmd.new(CmdReset.new(split[0], nil), opts) if split.size == 1
        end
      elsif args.size == 2
        return ParsedCmd.new(CmdReset.new(args[0], nil), opts) if args[1] == '='
      end

      helper = CmdSet.parse_cli(args).cmd
      ParsedCmd.new(CmdReset.new(helper.name, helper), opts)
    end

    def self.parse_script(args)
      puts "#{Name} parse_script"
    end

    def initialize(name, helper)
      @name = name
      @helper = helper
    end

    attr_accessor :name, :helper

    def execute(ctx)
      ename = ctx.expand_name(@name)

      raise Envy::Error.new "reset: no such var '#{ename}'" if !ctx.raw_get(ename)

      if !@helper
        ctx.unset(ename)
      else
        @helper.name = @name
        @helper.execute(ctx)
      end
    end
  end
end
