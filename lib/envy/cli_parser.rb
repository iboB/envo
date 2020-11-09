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
    def initialize
      @cmds = {}
    end
    def add_cmd(name, parse_func)
      @cmds[name] = parse_func
    end
    def parse(argv)
      opts = []
      cmd = nil
      while !argv.empty?
        arg = argv.shift
        if CliParser.opt?(arg)
          opts << arg
        else
          break cmd = arg
        end
      end

      raise Envy::Error.new 'missing command' if !cmd
      raise Envy::Error.new "unknown command '#{cmd}'" if !@cmds[cmd]

      return ParsedCmd.new(@cmds[cmd].(cmd, argv), opts)
    end
  end
end
