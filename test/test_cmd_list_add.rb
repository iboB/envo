require_relative '../lib/envy'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envy

class TestCmdListAdd < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdListAdd.parse_cli_all ['--x', 'foo', '--z', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--z', '--y']
    assert_instance_of CmdListAdd, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar']
    assert_nil parsed.cmd.pos

    parsed = CmdListAdd.parse_cli_all ['--top', 'foo', '--back', 'bar', 'baz', '--y']
    assert_equal parsed.opts, ['--y']
    assert_instance_of CmdListAdd, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar', 'baz']
    assert_equal parsed.cmd.pos, :back

    parsed = CmdListAdd.parse_cli_all ['foo', '--bottom', 'bar', '--front']
    assert_equal parsed.opts, []
    assert_instance_of CmdListAdd, parsed.cmd
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
    parser = CliParser.new(MockOpts)
    CmdListAdd.register_cli_parser(parser)
    parsed = parser.parse(['-f', 'la', '-b', '--top', 'name', 'v1', 'v2'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdListAdd, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name, 'name'
    assert_equal parsed.cmds[0].cmd.values, ['v1', 'v2']
    assert_equal parsed.cmds[0].cmd.pos, :front
    assert_equal parsed.cmds[0].opts, {bar: true}
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdListAdd.new('list123', [StringVal.new('boo')], nil)
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['list123']
    assert_equal ctx.sets.values[0].ar, ['val', 'list123', 'boo']

    ctx.reset
    cmd.name = 'str123'
    ctx.answers = [true]
    cmd.pos = :front
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['str123']
    assert_equal ctx.sets.values[0].ar, ['boo', 'str123']
    assert_equal ctx.questions, ['str123 is not a list, but a string. Convert?']

    ctx.reset
    ctx.answers = [false]
    assert_raise(Envy::Error.new "list-add: adding list item to a non-list") do
      cmd.execute(ctx)
    end

    ctx.reset
    ctx.answers = [true, true]
    cmd.values = [StringVal.new('a'), StringVal.new(''), StringVal.new('b')]
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['str123']
    assert_equal ctx.sets.values[0].ar, ['a', '', 'b', 'str123']
    assert_equal ctx.questions, ['str123 is not a list, but a string. Convert?', 'Add empty string to str123?']

    ctx.reset
    ctx.answers = [true, false]
    assert_raise(Envy::Error.new "list-add: adding empty string to str123") do
      cmd.execute(ctx)
    end

    ctx.reset
    ctx.answers = [true, true]
    cmd.name = 'plist2'
    cmd.values = [PathVal.new(ctx.sys, '/zz/ww'), StringVal.new('hoho')]
    cmd.pos = :back
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['plist2']
    assert_equal ctx.sets.values[0].ar, ['/aa/bb/plist2', '/zz/ww', 'hoho']
    assert_equal ctx.questions, ['Add non-existing path to plist2?', 'Add string to path list?']

    ctx.reset
    ctx.answers = [true, false]
    assert_raise(Envy::Error.new "list-add: adding string to path list") do
      cmd.execute(ctx)
    end
  end
end
