require_relative '../lib/envy'

puts Envy::VERSION
puts Envy::VERSION_TYPE

include Envy

COMMANDS = [CmdUnset]

parser = CliParser.new
COMMANDS.each { |cmd| cmd.register_cli_parser(parser) }

parsed = parser.parse(ARGV)

class TestSystem
  def initialize
    @env = {'foo' => '123', 'del' => 'xxx', 'del2' => 'yyy', 'path' => 'something'}
  end
  attr :env
end

class Context
  def initialize
    @state = State.new(TestSystem.new)
  end
  attr :state
  def expand_name(str)
    str
  end
end

ctx = Context.new

parsed.cmd.execute(ctx)

p ctx.state.diff
