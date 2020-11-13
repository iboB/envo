require_relative '../lib/envo'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envo

class TestCmdSwap < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdSwap.parse_cli ['--x', 'foo', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--y']
    assert_instance_of CmdSwap, parsed.cmd
    assert_equal parsed.cmd.name_a, 'foo'
    assert_equal parsed.cmd.name_b, 'bar'

    error = "swap: provide two names to swap. Use 'swap <name1> <name2>'"
    assert_raise(Envo::Error.new error) do
      CmdSwap.parse_cli []
    end

    assert_raise(Envo::Error.new error) do
      CmdSwap.parse_cli ['--a', 'b']
    end

    assert_raise(Envo::Error.new error) do
      CmdSwap.parse_cli ['a', 'b', 'c']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdSwap.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'swap', '--bar', 'name', 'name2', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdSwap, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name_a, 'name'
    assert_equal parsed.cmds[0].cmd.name_b, 'name2'
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  def test_script_parser
    parser = ScriptParser.new(MockOpts)
    CmdSwap.register_script_parser(parser)
    parsed = parser.parse(['swap name name2'])
    assert_empty parsed.opts
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdSwap, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name_a, 'name'
    assert_equal parsed.cmds[0].cmd.name_b, 'name2'
    assert_empty parsed.cmds[0].opts
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdSwap.new('str123', 'str00')
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['str123', 'str00']
    assert_equal ctx.sets.values, ['str00', 'str123']

    ctx.reset
    cmd.name_a = 'foo'
    assert_raise(Envo::Error.new "swap: no such var 'foo'") do
      cmd.execute(ctx)
    end

    ctx.reset
    ctx.interactivity = :force
    cmd.name_a = 'foo'
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['foo', 'str00']
    assert_equal ctx.sets.values, ['str00', nil]

    ctx.reset
    cmd.name_a = 'str34'
    cmd.name_b = 'foo'
    assert_raise(Envo::Error.new "swap: no such var 'foo'") do
      cmd.execute(ctx)
    end
  end
end
