require_relative '../lib/envy/shell/bash'
require 'test/unit'

class TestPlatformUnixLike < Test::Unit::TestCase
  S = Envy::Shell::Bash

  def test_lists
    assert_equal S.ar_to_list(['x', 'y', 'z']), 'x:y:z'
    assert_equal S.list_to_ar('x:x'), ['x', 'x']

    assert S.likely_list?("a:b:c")
    assert S.likely_list?("xxx=1:yyy=2")
    assert !S.likely_list?("xxx;yyy")
    assert !S.likely_list?("xxx")
    assert !S.likely_list?("127.0.0.1:3000")
    assert !S.likely_list?("127.0.0.1:0.0")
    assert !S.likely_list?("https://boo.com:3000")
    assert !S.likely_list?("https://boo.com")
  end

  def test_paths
    assert S.likely_abs_path?('/home/xxx')
    assert S.likely_abs_path?('/usr/bin')
    assert !S.likely_abs_path?('c:\foo')
    assert !S.likely_abs_path?('c:/foo')
    assert !S.likely_abs_path?('x\y')
    assert !S.likely_abs_path?('\x\y')
    assert !S.likely_abs_path?('root/asd')

    assert_equal S.fix_path('foo/bar'), 'foo/bar'
    assert_equal S.fix_path('/x\y/z'), '/x\y/z'
  end

  def test_env
    assert_equal S.cmd_set_env_var('foo', 'bar'), 'export foo="bar"'
    assert_equal S.cmd_set_env_var('FOO', 'b"a"z\\\'r\''), "export FOO=\"b\\\"a\\\"z\\\\\\'r\\'\""
    assert_equal S.cmd_unset_env_var('FoO'), 'unset -v FoO'
  end
end
