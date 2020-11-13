require_relative '../lib/envo'
require_relative 'mock_opts'
require_relative 'mock_ctx'
require 'test/unit'

include Envo

class TestCmdShow < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdShow.parse_cli ['--x', 'foo', 'bar', '--y']
    assert_equal parsed.opts, ['--x', '--y']
    assert_instance_of CmdShow, parsed.cmd
    assert_equal parsed.cmd.names, ['foo', 'bar']
    assert !parsed.cmd.show_names

    parsed = CmdShow.parse_cli ['--x', 'foo', 'bar', '--name']
    assert_equal parsed.opts, ['--x']
    assert_instance_of CmdShow, parsed.cmd
    assert_equal parsed.cmd.names, ['foo', 'bar']
    assert parsed.cmd.show_names

    assert_raise(Envo::Error.new 'show: no names provided') do
      CmdShow.parse_cli []
    end

    assert_raise(Envo::Error.new 'show: no names provided') do
      CmdShow.parse_cli ['--a', '-b']
    end
  end

  def test_cli_parser
    parser = CliParser.new(MockOpts)
    CmdShow.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'show', '--bar', 'name', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdShow, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.names, ['name']
    assert !parsed.cmds[0].cmd.show_names
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}

    parsed = parser.parse(['s', '--name', 'name'])
    assert_empty parsed.opts
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdShow, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.names, ['name']
    assert parsed.cmds[0].cmd.show_names
    assert_equal parsed.cmds[0].opts, {}

    parsed = parser.parse(['rshow', 'name'])
    assert_empty parsed.opts
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdShow, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.names, ['name']
    assert !parsed.cmds[0].cmd.show_names
    assert_equal parsed.cmds[0].opts, {raw: true}
  end

  def test_script_parser
    parser = ScriptParser.new(MockOpts)
    CmdShow.register_script_parser(parser)
    parsed = parser.parse(['{foo,name} show name'])
    assert_empty parsed.opts
    assert_equal parsed.cmds.size, 1
    assert_instance_of CmdShow, parsed.cmds[0].cmd
    assert_equal parsed.cmds[0].cmd.names, ['name']
    assert parsed.cmds[0].cmd.show_names
    assert_equal parsed.cmds[0].opts, {foo: true}
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdShow.new(['str', 'path', 'list', 'plist'], true)
    ctx.raw = true
    cmd.execute(ctx)
    assert_equal ctx.log, [
      'i:str=str',
      'i:path=/xx/yy/path',
      'i:list=val:list',
      'i:plist=/zz/ww:/aa/bb/plist'
    ]
  end
end
