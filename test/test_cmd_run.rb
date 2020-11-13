require_relative '../lib/envy'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envy

class TestCmdRun < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdRun.parse_cli ['--x', 'foo', '--y']
    assert_equal parsed.opts, ['--x', '--y']
    assert_instance_of CmdRun, parsed.cmd
    assert_equal parsed.cmd.script, 'foo'

    error = "run: provide a single script name. Use 'run <script>'"
    assert_raise(Envy::Error.new error) do
      CmdRun.parse_cli []
    end

    assert_raise(Envy::Error.new error) do
      CmdRun.parse_cli ['--a', 'b', 'c']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdRun.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'run', '--bar', 'name', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdRun, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.script, 'name'
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  def test_execute
  end
end
