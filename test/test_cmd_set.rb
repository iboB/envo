require_relative '../lib/envy'
require_relative 'helper_opts'
require 'test/unit'

include Envy

class TestCmdSet < Test::Unit::TestCase
  def test_cli_parse
    parsed = CmdSet.parse_cli ['--x', 'foo', '=', 'bar', 'b az', '--y']
    assert_equal parsed.opts, ['--x', '--y']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar', 'b az']

    parsed = CmdSet.parse_cli ['--x', 'foo=', 'bar']
    assert_equal parsed.opts, ['--x']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo=bar', '--x']
    assert_equal parsed.opts, ['--x']
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo', '=bar']
    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdSet
    assert_equal parsed.cmd.name, 'foo'
    assert_equal parsed.cmd.value, ['bar']

    parsed = CmdSet.parse_cli ['foo', '=']
    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdUnset
    assert_equal parsed.cmd.names, ['foo']

    parsed = CmdSet.parse_cli ['foo=']
    assert_equal parsed.opts, []
    assert_equal parsed.cmd.class, CmdUnset
    assert_equal parsed.cmd.names, ['foo']

    assert_raise(Envy::Error.new "set: missing '='. Use 'set <name> = <val>'") do
      CmdSet.parse_cli []
    end

    assert_raise(Envy::Error.new "set: missing '='. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['a', 'b', 'c', '--foo']
    end

    assert_raise(Envy::Error.new "set: bad name ''. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['=']
    end

    assert_raise(Envy::Error.new "set: bad name ''. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['=b']
    end

    assert_raise(Envy::Error.new "set: bad name 'a b'. Use 'set <name> = <val>'") do
      CmdSet.parse_cli ['a', 'b', '=']
    end
  end

  def test_cli_parser
    parser = CliParser.new(HelperOpts)
    CmdSet.register_cli_parser(parser)
    parsed = parser.parse(['--foo', 'set', '--bar', 'foo', '=', 'bar', '-z'])
    assert_equal parsed.opts, {foo: true}
    assert_equal parsed.cmds.size, 1
    assert_equal parsed.cmds[0].cmd.class, CmdSet
    assert_equal parsed.cmds[0].cmd.name, 'foo'
    assert_equal parsed.cmds[0].cmd.value, ['bar']
    assert_equal parsed.cmds[0].opts, {bar: true, baz: true}
  end

  class MockSys
    def self.path_exists?(path)
      false
    end
  end

  class MockCtx
    def expand_name(name)
      name
    end
    def expand_value(val)
      val
    end
    def smart_get(name)
      case name
      when /^str/ then return StringVal.new(name)
      when /^list/ then return ListVal.new(['val', name])
      when /^path/ then return PathVal.new(MockSys, '/xx/yy/' + name)
      when /^plist/ then return PathListVal.new(MockSys, ['/zz/ww', '/aa/bb/' + name])
      else return NoVal.new
      end
    end

    attr_accessor :name_set, :val_set
    def smart_set(name, val)
      @name_set = name
      @val_set = val
    end

    attr_accessor :questions, :answers
    def ask(q)
      questions << q
      answers.shift
    end

    def reset
      @name_set = nil
      @val_set = nil
      @questions = []
      @answers = nil
    end

    def initialize
      reset
    end
  end

  def test_execute
    ctx = MockCtx.new
    cmd = CmdSet.new('str', StringVal.new('asdf'))

    cmd.execute(ctx)
    assert_equal ctx.name_set, 'str'
    assert_same ctx.val_set, cmd.value
    assert_empty ctx.questions

    ctx.reset
    cmd.name = 'foo'
    cmd.execute(ctx)
    assert_equal ctx.name_set, 'foo'
    assert_same ctx.val_set, cmd.value
    assert_empty ctx.questions

    ctx.reset
    cmd.name = 'list'
    ctx.answers = [true]
    cmd.execute(ctx)
    assert_equal ctx.name_set, 'list'
    assert_same ctx.val_set, cmd.value
    assert_equal ctx.questions, ['Assign string to list?']

    ctx.reset
    ctx.answers = [false]
    assert_raise(Envy::Error.new 'set: assignment of string to list') do
      cmd.execute(ctx)
    end

    ctx.reset
    cmd.name = 'path32'
    cmd.value = PathVal.new(MockSys, '/foo/bar')
    ctx.answers = [true]
    cmd.execute(ctx)
    assert_equal ctx.name_set, 'path32'
    assert_same ctx.val_set, cmd.value
    assert_equal ctx.questions, ['Assign non-existing path to path32?']

    ctx.reset
    ctx.answers = [false]
    assert_raise(Envy::Error.new 'set: assignment of non-existing path to path32') do
      cmd.execute(ctx)
    end
  end
end
