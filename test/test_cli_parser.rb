require_relative '../lib/envy'
require_relative 'helper_opts'
require 'test/unit'

include Envy

class TestCliParser < Test::Unit::TestCase
  def test_utils
    assert CliParser.opt?('--foo')
    assert CliParser.opt?('-bar')
    assert !CliParser.opt?('fo-o')
    assert !CliParser.opt?('bar--')

    a = ['a', 'b', 'c']
    assert_equal CliParser.filter_opts(a), []
    assert_equal a, ['a', 'b', 'c']

    a = ['-x', '--y', 'a', 'b', 'c']
    assert_equal CliParser.filter_opts(a), ['-x', '--y']
    assert_equal a, ['a', 'b', 'c']

    a = ['a', 'b', 'c', '-z', '--w']
    assert_equal CliParser.filter_opts(a), ['-z', '--w']
    assert_equal a, ['a', 'b', 'c']

    a = ['-x', '--y', 'a', 'b', 'c', '-z', '--w']
    assert_equal CliParser.filter_opts(a), ['-x', '--y', '-z', '--w']
    assert_equal a, ['a', 'b', 'c']
  end
  def test_basic
    parser = CliParser.new(HelperOpts)

    parser.add_cmd('foo', ->(cmd, args) {
      assert_equal cmd, 'foo'
      assert_equal args, ['stuff', '--for', 'cmd foo']
      ParsedCmd.new(123, [])
    })
    parser.add_cmd('bar', ->(cmd, args) {
      assert_equal cmd, 'bar'
      assert_equal args, ['cmdbar', 'things']
      ParsedCmd.new(567, ['--bar'])
    })

    res = parser.parse(['foo', 'stuff', '--for', 'cmd foo'])
    assert_equal res.opts, {}
    assert_equal res.cmds.size, 1
    assert_equal res.cmds[0].cmd, 123
    assert_equal res.cmds[0].opts, {}

    res = parser.parse(['--foo', '-z', 'bar', 'cmdbar', 'things'])
    assert_equal res.opts, {foo: true, baz: true}
    assert_equal res.cmds.size, 1
    assert_equal res.cmds[0].cmd, 567
    assert_equal res.cmds[0].opts, {bar: true}

    assert_raise(Envy::Error.new '--opt1') do
      parser.parse(['--opt1', '-opt2'])
    end

    assert_raise(Envy::Error.new 'missing command') do
      parser.parse(['--foo', '-b'])
    end

    assert_raise(Envy::Error.new "unknown command 'baz'") do
      parser.parse(['-f', 'baz', '-z'])
    end
  end
end
