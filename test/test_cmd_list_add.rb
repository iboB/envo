require_relative '../lib/envy'
require_relative 'helper_opts'
require 'test/unit'

include Envy

class TestCmdListAdd < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdListAdd.parse_cli_all ['--x', 'foo', '--z', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--z', '--y']
    assert_equal parsed.cmd.class, CmdListAdd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar']
    assert_nil parsed.cmd.pos

    parsed = CmdListAdd.parse_cli_all ['--top', 'foo', '--back', 'bar', 'baz', '--y']
    assert_equal parsed.opts, ['--y']
    assert_equal parsed.cmd.class, CmdListAdd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar', 'baz']
    assert_equal parsed.cmd.pos, :back

    parsed = CmdListAdd.parse_cli_all ['foo', '--bottom', 'bar', '--front']
    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdListAdd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar']
    assert_equal parsed.cmd.pos, :front

    assert_raise(Envy::Error.new "list-add: missing name. Use 'la <name> <val>'") do
      CmdListAdd.parse_cli_all ['--x']
    end

    assert_raise(Envy::Error.new "list-add: no values to add provided") do
      CmdListAdd.parse_cli_all ['foo', '--a', '--b']
    end
  end

  def test_cli_parser
    parser = CliParser.new(HelperOpts)
    CmdListAdd.register_cli_parser(parser)
    parsed = parser.parse(['-f', 'la', '-b', '--top', 'name', 'v1', 'v2'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_equal parsed.cmds[0].cmd.class, CmdListAdd
    assert_equal parsed.cmds[0].cmd.name, 'name'
    assert_equal parsed.cmds[0].cmd.values, ['v1', 'v2']
    assert_equal parsed.cmds[0].cmd.pos, :front
    assert_equal parsed.cmds[0].opts, {bar: true}
  end

  def test_execute
  end
end
