require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestCmdUnset < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdUnset.parse_cli ['--x', 'foo', 'bar', '--y']

    assert_equal parsed.opts, ['--x', '--y']
    cmd = parsed.cmd
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
    parser = CliParser.new
    CmdUnset.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'unset', '--bar', 'name', '-baz'])
    assert_equal parsed.opts, ['--foo', '--bar', '-baz']
    cmd = parsed.cmd
    assert_equal parsed.cmd.class, CmdUnset
    assert_equal parsed.cmd.names, ['name']
  end
end
