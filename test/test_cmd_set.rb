require_relative '../lib/envy'
require_relative 'helper_opts'
require 'test/unit'

include Envy

class TestCmdSet < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdSet.parse_cli ['--x', 'foo', '=', 'bar', 'b az', '--y']

    assert_equal parsed.opts, ['--x', '--y']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar', 'b az']

    parsed = CmdSet.parse_cli ['--x', 'foo=', 'bar']

    assert_equal parsed.opts, ['--x']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo=bar', '--x']

    assert_equal parsed.opts, ['--x']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo', '=bar']

    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo', '=']

    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, []

    parsed = CmdSet.parse_cli ['foo=']

    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, []

    assert_raise(Envy::Error.new "set: missing '='. Use 'set <name> = <val>'") do
      CmdSet.parse_cli []
    end

    assert_raise(Envy::Error.new "set: missing '='. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['a', 'b', 'c', '--foo']
    end

    assert_raise(Envy::Error.new "set: bad name ''. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['=']
    end

    assert_raise(Envy::Error.new "set: bad name ''. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['=b']
    end

    assert_raise(Envy::Error.new "set: bad name 'a b'. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['a', 'b', '=']
    end
  end

  def test_cli_parser
    parser = CliParser.new(HelperOpts)
    CmdSet.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'set', '--bar', 'foo', '=', 'bar', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_equal parsed.cmds[0].cmd.class, CmdSet
    assert_equal parsed.cmds[0].cmd.name, 'foo'
    assert_equal parsed.cmds[0].cmd.value, ['bar']
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  # def test_execute
  # end
end
