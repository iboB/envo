module Envy
  class ParsedCmd
    def initialize(cmd, opts)
      @cmd = cmd
      @opts = opts
    end
    attr_reader :cmd
    attr_accessor :opts
  end
end
