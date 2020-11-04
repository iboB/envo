require_relative '../lib/envy/platform.rb'
require 'test/unit'

include Envy

class TestPlatformWindows < Test::Unit::TestCase
  P = Platform::Windows

  def test_name
    assert_equal P.name, 'Windows'
  end

  def test_lists
    assert_equal P.list_sep, ';'
    assert_equal P.a_to_v([1, 2, 3]), '1;2;3'
    assert_equal P.v_to_a('a;b;c'), ['a', 'b', 'c']

    assert P.likely_list?("a;b;c")
    assert P.likely_list?("xxx=1;yyy=2")
    assert !P.likely_list?("xxx:yyy")
    assert !P.likely_list?("xxx")
  end

  def test_paths
    assert P.likely_absolute_path?('c:\x')
    assert P.likely_absolute_path?('x:\foo')
    assert !P.likely_absolute_path?('c:')
    assert !P.likely_absolute_path?('c:/foo')
    assert !P.likely_absolute_path?('cc:/foo')
    assert !P.likely_absolute_path?('x\y')
    assert !P.likely_absolute_path?('\x\y')
    assert !P.likely_absolute_path?('/root/asd')
  end
end

class TestPlatformUnixLike < Test::Unit::TestCase
  P = Platform::UnixLike

  def test_name
    assert_equal P.name, 'UnixLike'
  end

  def test_lists
    assert_equal P.list_sep, ':'
    assert_equal P.a_to_v(['x', 'y', 'z']), 'x:y:z'
    assert_equal P.v_to_a('x:x'), ['x', 'x']

    assert P.likely_list?("a:b:c")
    assert P.likely_list?("xxx=1:yyy=2")
    assert !P.likely_list?("xxx;yyy")
    assert !P.likely_list?("xxx")
    assert !P.likely_list?("127.0.0.1:3000")
    assert !P.likely_list?("127.0.0.1:0.0")
    assert !P.likely_list?("https://boo.com:3000")
    assert !P.likely_list?("https://boo.com")
  end

  def test_paths
    assert P.likely_absolute_path?('/home/xxx')
    assert P.likely_absolute_path?('/usr/bin')
    assert !P.likely_absolute_path?('c:\foo')
    assert !P.likely_absolute_path?('c:/foo')
    assert !P.likely_absolute_path?('x\y')
    assert !P.likely_absolute_path?('\x\y')
    assert !P.likely_absolute_path?('root/asd')
  end
end
