require_relative '../lib/envo'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envo

class TestCmdListDel < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdListDel.parse_cli_all ['--x', 'foo', '--z', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--z', '--y']
    assert_instance_of CmdListDel, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, 'bar'

    assert_raise(Envo::Error.new "list-del: missing name. Use 'ld <name> <val|index>'") do
      CmdListDel.parse_cli_all ['--x']
    end

    assert_raise(Envo::Error.new "list-del: provide one value or index to delete. Use 'list <name> del <val|index>'") do
      CmdListDel.parse_cli_all ['foo', '--a', '--b']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdListDel.register_cli_parser(parser)
    parsed = parser.parse(['-f', 'ld', '-b', 'name', 'v1'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdListDel, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name, 'name'
    assert_equal parsed.cmds[0].cmd.value, 'v1'
    assert_equal parsed.cmds[0].opts, {bar: true}
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdListDel.new('list123', StringVal.new('val'))
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['list123']
    assert_equal ctx.sets.values[0].ar, ['list123']

    ctx.reset
    cmd.name = 'foo'
    assert_raise(Envo::Error.new "list-del: deleting an item from a non-exiting value") do
      cmd.execute(ctx)
    end

    ctx.reset
    ctx.interactivity = :force
    cmd.execute(ctx)
    assert_empty ctx.sets

    ctx.reset
    cmd.name = 'str5'
    ctx.answers = [false]
    assert_raise(Envo::Error.new "list-del: deleting an item from a non-list") do
      cmd.execute(ctx)
    end
    assert_equal ctx.questions, ["str5 is not a list, but a string. Convert?"]

    ctx.reset
    ctx.answers = [true]
    assert_raise(Envo::Error.new "list-del: no item 'val' in str5") do
      cmd.execute(ctx)
    end

    ctx.reset
    cmd.value = StringVal.new('str5')
    ctx.answers = [true]
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['str5']
    assert_equal ctx.sets.values[0].ar, []

    ctx.reset
    cmd.name = 'list44'
    cmd.value = StringVal.new('1')
    cmd.execute(ctx)
    assert_equal ctx.sets.keys, ['list44']
    assert_equal ctx.sets.values[0].ar, ['val']

    ctx.reset
    cmd.value = StringVal.new('10')
    assert_raise(Envo::Error.new "list-del: no index 10 in list44") do
      cmd.execute(ctx)
    end
  end
end
