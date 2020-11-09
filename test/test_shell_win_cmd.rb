require_relative '../lib/envy/shell/win_cmd'
require 'test/unit'

class TestPlatformWinCmd < Test::Unit::TestCase
  S = Envy::Shell::WinCmd

  def test_lists
    assert_equal S.ar_to_list([1, 2, 3]), '1;2;3'
    assert_equal S.list_to_ar('a;b;c'), ['a', 'b', 'c']

    assert S.likely_list?("a;b;c")
    assert S.likely_list?("xxx=1;yyy=2")
    assert !S.likely_list?("xxx:yyy")
    assert !S.likely_list?("xxx")
  end

  def test_paths
    assert S.likely_abs_path?('c:\x')
    assert S.likely_abs_path?('x:\foo')
    assert !S.likely_abs_path?('c:')
    assert !S.likely_abs_path?('d:/foo')
    assert !S.likely_abs_path?('cc:/foo')
    assert !S.likely_abs_path?('x\y')
    assert !S.likely_abs_path?('\x\y')
    assert !S.likely_abs_path?('/root/asd')

    assert_equal S.fix_path('foo/bar'), 'foo\bar'
    assert_equal S.fix_path('c:/foo\bar/baz'), 'c:\foo\bar\baz'
  end

  def test_env
    assert_equal S.cmd_set_env_var('foo', 'bar'), 'set foo=bar'
    assert_equal S.cmd_set_env_var('FOO', 'b"a"z\\\'r\''), 'set FOO=b"a"z\\\'r\''
    assert_equal S.cmd_unset_env_var('FoO'), 'set FoO='
  end
end
