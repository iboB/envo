module Envy
  class ParseResult
    def initialize()
      @opts = {}
      @cmds = []
    end
    attr_accessor :opts, :cmds
  end
end
