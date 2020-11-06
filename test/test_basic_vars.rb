require_relative '../lib/envy/no_var'
require_relative '../lib/envy/string_var'
require 'test/unit'

include Envy

class TestBasicVars < Test::Unit::TestCase
  def test_no_var
    nv = NoVar.new('ttt');
    assert_equal nv.name, 'ttt'
    assert_nil nv.value
    assert_nil nv.to_env_val

    nv.name = 'name'
    assert_equal nv.name, 'name'
  end

  def test_string_var
    sv = StringVar.new('name', 'val');
    assert_equal sv.name, 'name'
    assert_equal sv.value, 'val'
    assert_equal sv.to_env_val, 'val'

    sv.name = 'name2'
    sv.value = '3value'
    assert_equal sv.name, 'name2'
    assert_equal sv.value, '3value'
    assert_equal sv.to_env_val, '3value'
  end
end
