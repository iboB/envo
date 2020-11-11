require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestValBuilder < Test::Unit::TestCase
  module W
    extend self
    def shell
      Shell::WinCmd
    end
    def pwd
      'C:\programs\envy'
    end
  end

  module B
    extend self
    def shell
      Shell::Bash
    end
    def pwd
      '/home/alice/envy'
    end
  end

  def test_env_no_val
    nv = ValBuilder.from_env_string(nil, nil)
    assert_instance_of NoVal, nv
  end

  def test_env_string_val
    sv = ValBuilder.from_env_string('foo', B)
    assert_instance_of StringVal, sv
    assert_equal sv.value, 'foo'
  end

  def test_env_list_b
    lv = ValBuilder.from_env_string('bar:baz:boz', B)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_env_list_w
    lv = ValBuilder.from_env_string('bar;baz;boz', W)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_env_path_b
    pv = ValBuilder.from_env_string('/usr/lib/foo', B)
    assert_instance_of PathVal, pv
    assert_equal pv.path, '/usr/lib/foo'
  end

  def test_env_path_w
    pv = ValBuilder.from_env_string("D:\\program files\\zzz", W)
    assert_instance_of PathVal, pv
    assert_equal pv.path, "D:\\program files\\zzz"
  end

  def test_env_path_list_b
    plv = ValBuilder.from_env_string('/usr/lib/foo:/home/john', B)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ['/usr/lib/foo', '/home/john']
  end

  def test_env_path_list_w
    plv = ValBuilder.from_env_string("c:\\temp\\xx;d:\\yyy", W)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ["c:\\temp\\xx", "d:\\yyy"]
  end

  #######################################

  def test_user_no_val
    nv = ValBuilder.from_user_text([], nil)
    assert_instance_of NoVal, nv
  end

  def test_user_string_val
    sv = ValBuilder.from_user_text('foo', B)
    assert_instance_of StringVal, sv
    assert_equal sv.value, 'foo'
    sv = ValBuilder.from_user_text(['foo'], B)
    assert_instance_of StringVal, sv
    assert_equal sv.value, 'foo'
  end

  def test_user_list
    lv = ValBuilder.from_user_text(['bar', 'baz', 'boz'], B)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_user_path_b
    pv = ValBuilder.from_user_text('/usr/lib/foo', B)
    assert_instance_of PathVal, pv
    assert_equal pv.path, '/usr/lib/foo'

    pv = ValBuilder.from_user_text(['../lib/foo'], B)
    assert_instance_of PathVal, pv
    assert_equal pv.path, '/home/alice/lib/foo'
  end

  def test_user_path_w
    pv = ValBuilder.from_user_text(["D:\\program files\\zzz"], W)
    assert_instance_of PathVal, pv
    assert_equal pv.path, "D:\\program files\\zzz"

    # no rel test for wincmd as we pathname doesn't work
  end

  def test_user_path_list_b
    plv = ValBuilder.from_user_text(['/usr/lib/foo', './xx'], B)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ['/usr/lib/foo', '/home/alice/envy/xx']
  end

  def test_user_path_list_w
    plv = ValBuilder.from_user_text(["c:\\temp\\xx", "d:\\yyy"], W)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ["c:\\temp\\xx", "d:\\yyy"]
  end
end
