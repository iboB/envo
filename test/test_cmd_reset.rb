require_relative '../lib/envy'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envy

class TestCmdReset < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdReset.parse_cli ['--x', 'foo', '=', 'bar', 'b az', '--y']
    assert_equal parsed.opts, ['--x', '--y']
    assert_instance_of CmdReset, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_instance_of CmdSet, parsed.cmd.helper
    assert_equal parsed.cmd.helper.value, ['bar', 'b az']

    parsed = CmdReset.parse_cli ['foo=bar']
    assert_equal parsed.opts, []
    assert_instance_of CmdReset, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_instance_of CmdSet, parsed.cmd.helper
    assert_equal parsed.cmd.helper.value, ['bar']

    parsed = CmdReset.parse_cli ['foo']
    assert_equal parsed.opts, []
    assert_instance_of CmdReset, parsed.cmd
    assert_nil parsed.cmd.helper

    parsed = CmdReset.parse_cli ['foo=']
    assert_equal parsed.opts, []
    assert_instance_of CmdReset, parsed.cmd
    assert_nil parsed.cmd.helper

    parsed = CmdReset.parse_cli ['foo', '=']
    assert_equal parsed.opts, []
    assert_instance_of CmdReset, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_nil parsed.cmd.helper

    assert_raise(Envy::Error.new "reset: missing name. Use 'reset <name> [= [<val>]]'") do
      CmdReset.parse_cli []
    end
    assert_raise(Envy::Error.new "reset: missing name. Use 'reset <name> [= [<val>]]'") do
      CmdReset.parse_cli ['=zz']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdReset.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'reset', '--bar', 'foo', '=', 'bar', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdReset, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name, 'foo'
    assert_instance_of CmdSet, parsed.cmds[0].cmd.helper
    assert_equal parsed.cmds[0].cmd.helper.value, ['bar']
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdReset.new('str', nil)
    cmd.execute(ctx)
    assert_equal ctx.unsets, ['str']

    ctx.reset
    cmd.name = 'foo'
    assert_raise(Envy::Error.new "reset: no such var 'foo'") do
      cmd.execute(ctx)
    end

    ctx.reset
    cmd.helper = CmdSet.new(nil, StringVal.new('bar'))
    assert_raise(Envy::Error.new "reset: no such var 'foo'") do
      cmd.execute(ctx)
    end

    ctx.reset
    cmd.name = 'str123'
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['str123']
    assert_same ctx.sets.values[0], cmd.helper.value
  end
end
