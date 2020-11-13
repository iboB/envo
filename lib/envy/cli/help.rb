module Envy
  module Cli
    class Help
      def initialize
        @commands = []
      end
      def add_cmd(usage, text)
        @commands << [usage, text]
      end
      def print(stream)
        @commands.each do |cmd|
          stream.puts "  * #{cmd[0]}"
          cmd[1].each_line do |line|
            stream.puts "        #{line}"
          end
        end
      end
    end
  end
end
