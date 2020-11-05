module Envy
  class Error < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end
