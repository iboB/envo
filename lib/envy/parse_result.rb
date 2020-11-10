module Envy
  class ParseResult
    def initialize()
      @opts = {}
      @cmds = []
    end
    def add_opt(k, v)
      @opts[k] = v
    end
    def add_cmd(cmd, opts)
      @cmds << ParsedCmd.new(cmd, opts)
    end
    attr_accessor :opts, :cmds
  end
end
