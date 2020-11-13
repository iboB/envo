require_relative '../lib/envo'
require_relative 'mock_opts'
require 'test/unit'

include Envo

class TestScriptParser < Test::Unit::TestCase
  def test_basic
    parser = ScriptParser.new(MockOpts)

    parser.add_cmd('foo', ->(cmd, tokens, opts) {
      assert_equal cmd, 'foo'
      assert_equal tokens, ['stuff', 'for', 'cmd foo']
      assert_equal opts, ['a', 'b']
      ParsedCmd.new(123, ['foo'])
    })
    parser.add_cmd('bar', ->(cmd, tokens, opts) {
      assert_equal cmd, 'bar'
      assert_equal tokens, ['some cmdbar', 'things']
      assert_empty opts
      ParsedCmd.new(567, ['bar'])
    })

    res = parser.parse([
      '   # comment',
      '   {a,b}  foo stuff for "cmd foo"',
      'bar "some cmdbar" things',
      '#final comment',
    ])

    assert_equal res.opts, {}
    assert_equal res.cmds.size, 2
    assert_equal res.cmds[0].cmd, 123
    assert_equal res.cmds[0].opts, {foo: true}
    assert_equal res.cmds[1].cmd, 567
    assert_equal res.cmds[1].opts, {bar: true}

    assert_raise(Envo::Error.new '1: missing command') do
      parser.parse(['{foo,bar}'])
    end
    assert_raise(Envo::Error.new '1: missing command') do
      parser.parse(['{foo,bar}   '])
    end
    assert_raise(Envo::Error.new '1: unknown command \'xxx\'') do
      parser.parse(['{foo,bar}  xxx '])
    end
    assert_raise(Envo::Error.new '1: malformed options pack') do
      parser.parse(['{foo,bar  xxx '])
    end
  end
end
