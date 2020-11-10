module Envy
  class CliParser
    def self.opt?(opt)
      opt =~ /^-/
    end
    def self.filter_opts(args)
      front_opts = args.take_while { |a| opt?(a) }
      args.shift(front_opts.size)
      back_opts = args.reverse.take_while { |a| opt?(a) }.reverse
      args.pop(back_opts.size)
      front_opts + back_opts
    end
    def initialize(opts)
      @known_cmds = {}
      @known_opts = opts
    end
    def add_cmd(name, parse_func)
      @known_cmds[name] = parse_func
    end
    def parse(argv)
      result = ParseResult.new
      cmd = nil
      while !argv.empty?
        arg = argv.shift
        if CliParser.opt?(arg)
          result.opts.merge! @known_opts.parse_cli(arg)
        else
          break cmd = arg
        end
      end

      raise Envy::Error.new 'missing command' if !cmd
      raise Envy::Error.new "unknown command '#{cmd}'" if !@known_cmds[cmd]

      parsed_cmd = @known_cmds[cmd].(cmd, argv)

      cmd_opts = {}
      parsed_cmd.opts.each do |opt|
        cmd_opts.merge! @known_opts.parse_cli(opt)
      end
      parsed_cmd.opts = cmd_opts

      result.cmds << parsed_cmd
      result
    end
  end
end
