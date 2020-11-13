require_relative '../lib/envy'
require_relative 'mock_opts'
require 'test/unit'

include Envy

class TestCmdList < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdList.parse_cli ['--x', 'foo']
    assert_equal parsed.opts, ['--x']
    assert_instance_of CmdShow, parsed.cmd
    assert_equal parsed.cmd.names, ['foo']
    assert parsed.cmd.show_names

    parsed = CmdList.parse_cli ['--top', 'foo', 'add', '--back', 'bar', 'baz', '--y']
    assert_equal parsed.opts, ['--y']
    assert_instance_of CmdListAdd, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.values, ['bar', 'baz']
    assert_equal parsed.cmd.pos, :back

    parsed = CmdList.parse_cli ['--x', 'foo', 'del', '--z', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--z', '--y']
    assert_instance_of CmdListDel, parsed.cmd
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, 'bar'

    assert_raise(Envy::Error.new "list: missing name. Use 'list <name> <cmd> <args>'") do
      CmdList.parse_cli ['--x']
    end

    assert_raise(Envy::Error.new "list: unkonwn subcommand zzz") do
      CmdList.parse_cli ['foo', 'zzz', '--a', '--b']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdList.register_cli_parser(parser)
    parsed = parser.parse(['-f', 'list', 'name', 'add', '-b', '--top', 'v1', 'v2'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdListAdd, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name, 'name'
    assert_equal parsed.cmds[0].cmd.values, ['v1', 'v2']
    assert_equal parsed.cmds[0].cmd.pos, :front
    assert_equal parsed.cmds[0].opts, {bar: true}
  end

  def test_script_parser
    parser = ScriptParser.new(MockOpts)
    CmdList.register_script_parser(parser)
    parsed = parser.parse [
      '{bar,top} list name add v1 "v2 2"',
      'list name2 del 2'
    ]
    assert_empty parsed.opts
    assert_equal parsed.cmds.size, 2
    assert_instance_of CmdListAdd, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.name, 'name'
    assert_equal parsed.cmds[0].cmd.values, ['v1', 'v2 2']
    assert_equal parsed.cmds[0].cmd.pos, :front
    assert_equal parsed.cmds[0].opts, {bar: true}
    assert_instance_of CmdListDel, parsed.cmds[1].cmd
    assert_equal parsed.cmds[1].cmd.name, 'name2'
    assert_equal parsed.cmds[1].cmd.value, '2'
    assert_equal parsed.cmds[1].opts, {}
  end
end
