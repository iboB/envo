module Envy
  class Context
    class Help
      def initialize
        @cmds = []
      end

      def add_cmd(name, text)
        @cmds << {name: name, text: text}
      end
    end

    def initialize
      @help = Help.new
    end

    def help
  end
end
