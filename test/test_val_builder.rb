require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestValBuilder < Test::Unit::TestCase
  B = Shell::Bash
  W = Shell::WinCmd

  def test_no_val
    nv = ValBuilder.from_env_string(nil, nil, nil)
    assert_instance_of NoVal, nv
  end

  def test_string_val
    sv = ValBuilder.from_env_string('foo', nil, B)
    assert_instance_of StringVal, sv
    assert_equal sv.value, 'foo'
  end

  def test_list_b
    lv = ValBuilder.from_env_string('bar:baz:boz', nil, B)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_list_w
    lv = ValBuilder.from_env_string('bar;baz;boz', nil, W)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_path_b
    pv = ValBuilder.from_env_string('/usr/lib/foo', nil, B)
    assert_instance_of PathVal, pv
    assert_equal pv.path, '/usr/lib/foo'
  end

  def test_path_w
    pv = ValBuilder.from_env_string("D:\\program files\\zzz", nil, W)
    assert_instance_of PathVal, pv
    assert_equal pv.path, "D:\\program files\\zzz"
  end

  def test_path_list_b
    plv = ValBuilder.from_env_string('/usr/lib/foo:/home/john', nil, B)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ['/usr/lib/foo', '/home/john']
  end

  def test_path_list_w
    plv = ValBuilder.from_env_string("c:\\temp\\xx;d:\\yyy", nil, W)
    assert_instance_of PathListVal, plv
    assert_equal plv.ar, ["c:\\temp\\xx", "d:\\yyy"]
  end
end
