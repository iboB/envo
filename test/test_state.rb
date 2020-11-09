require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestSystem
  def initialize
    @env = {}
  end
  attr_reader :env
  def merge_env(h)
    env.merge!(h)
  end
end

class TestState < Test::Unit::TestCase
  def test_basic
    sys = TestSystem.new
    sys.merge_env({'foo' => '123', 'del' => 'xxx', 'del2' => 'yyy', 'path' => 'something'})
    state = State.new(sys)
    assert_equal state.real_env['foo'], '123'

    patch = state.diff
    assert patch.empty?

    state.set('foo', 666)
    state.set('bar', 'baz')
    state.unset('del')
    state.set('del2', nil)
    state.unset('no_exist') # shouldn't cause problems

    patch = state.diff

    assert_equal patch.removed, ['del', 'del2']
    assert_equal patch.changed, {'foo' => '666'}
    assert_equal patch.added, {'bar' => 'baz'}
  end
end
