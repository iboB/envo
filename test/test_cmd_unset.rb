require_relative '../lib/envy'
require_relative 'helper_opts'
require 'test/unit'

include Envy

class TestCmdUnset < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdUnset.parse_cli ['--x', 'foo', 'bar', '--y']

    assert_equal parsed.opts, ['--x', '--y']
    assert_equal parsed.cmd.class, CmdUnset
    assert_equal parsed.cmd.names, ['foo', 'bar']

    assert_raise(Envy::Error.new 'unset: no names provided') do
      CmdUnset.parse_cli []
    end

    assert_raise(Envy::Error.new 'unset: no names provided') do
      CmdUnset.parse_cli ['--a', '-b']
    end
  end

  def test_cli_parser
    parser = CliParser.new(HelperOpts)
    CmdUnset.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'unset', '--bar', 'name', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_equal parsed.cmds[0].cmd.class, CmdUnset
    assert_equal parsed.cmds[0].cmd.names, ['name']
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  class MinCtx
    attr_accessor :env, :force, :unsets
    def initialize()
      @unsets = []
    end
    def expand_name(name)
      name
    end
    def raw_get(name)
      @env[name]
    end
    def unset(name)
      @unsets << name
    end
    def force?
      @force
    end
  end

  def test_execute
    ctx = MinCtx.new
    ctx.env = {'foo' => '1', 'bar' => 2, 'baz' => 3}
    ctx.force = true

    cmd = CmdUnset.new(['foo', 'faa'])
    cmd.execute(ctx)

    assert_equal ctx.unsets, ['foo']

    ctx.force = false
    assert_raise(Envy::Error.new "unset: no such var 'faa'") do
      cmd.execute(ctx)
    end
  end
end
