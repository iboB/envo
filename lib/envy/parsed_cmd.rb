module Envy
  class ParsedCmd
    def initialize(cmd, opts)
      if cmd.class == ParsedCmd
        @cmd = cmd.cmd
        @opts = opts + cmd.opts
      else
        @cmd = cmd
        @opts = opts
      end
    end
    attr_reader :cmd, :opts
  end
end
