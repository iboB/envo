module Envy
  class CliParser
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
        case arg
          when /^-/ then opts << arg
          else break cmd = arg
        end
      end

      raise Envy::Error.new 'missing command' if !cmd
      raise Envy::Error.new "unknown command '#{cmd}'" if !@cmds[cmd]

      return ParsedCmd.new(@cmds[cmd].(cmd, argv), opts)
    end
  end
end
