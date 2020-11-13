require_relative '../lib/envo'
require 'test/unit'

include Envo

class TestStringVal < Test::Unit::TestCase
  def test_casts
    s = StringVal.new('xyz')

    assert_equal s.type, :string
    assert !s.list?
    assert_equal s.value, 'xyz'
    s.clean!
    assert_equal s.value, 'xyz'
    assert_same s.to_s, s.value

    assert s.accept_assign?(5)

    assert !s.invalid_description

    l = s.to_list
    assert_equal l.type, :list
    assert_equal l.ar, ['xyz']

    s.value = ''
    assert_equal s.invalid_description, 'empty string'

    s.clean!
    assert_nil s.value
  end
end
