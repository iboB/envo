require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestVarBuilder < Test::Unit::TestCase
  U = System.new(Platform::UnixLike)
  W = System.new(Platform::Windows)

  def test_no_var
    nv = VarBuilder.build(U, 'foo', nil)
    assert_instance_of NoVar, nv
    assert_equal nv.name, 'foo'
    assert_equal nv.value, nil
  end

  def test_string_var
    sv = VarBuilder.build(U, 'foo', 'bar')
    assert_instance_of StringVar, sv
    assert_equal sv.name, 'foo'
    assert_equal sv.value, 'bar'
  end

  def test_list_u
    lv = VarBuilder.build(U, 'foo', 'bar:baz:boz')
    assert_instance_of ListVar, lv
    assert_equal lv.name, 'foo'
  end

  def test_list_w
    lv = VarBuilder.build(W, 'foo', 'bar;baz;boz')
    assert_instance_of ListVar, lv
    assert_equal lv.name, 'foo'
  end
end
