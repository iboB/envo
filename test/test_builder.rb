require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestBuilder < Test::Unit::TestCase
  def test_basic
    sys = System.new(Platform::UnixLike)
    sys.merge_env({'foo' => '123', 'del' => 'xxx', 'path' => 'something'})

    b = Builder.new(sys)
    assert_equal b.real_env['foo'], '123'

    b.set('foo', 666)
    b.set('bar', 'baz')
    b.unset('del')

    patch = b.diff

    assert_equal patch.removed, ['del']
    assert_equal patch.changed, {'foo' => '666'}
    assert_equal patch.added, {'bar' => 'baz'}
  end

  def test_lists
    sys = System.new(Platform::UnixLike)
    sys.merge_env({'foo' => '123', 'path' => '/home/user:/usr/bin:/usr/local/sbin'})
    b = Builder.new(sys)
  end
end
