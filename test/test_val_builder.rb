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

  def test_list_u
    lv = ValBuilder.from_env_string('bar:baz:boz', nil, B)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end

  def test_list_w
    lv = ValBuilder.from_env_string('bar;baz;boz', nil, W)
    assert_instance_of ListVal, lv
    assert_equal lv.ar, ['bar', 'baz', 'boz']
  end
end
