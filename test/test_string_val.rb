require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestStringVal < Test::Unit::TestCase
  def test_casts
    s = StringVal.new('xyz')

    assert_equal s.type, :string
    assert !s.list?

    assert s.accept_assign?(5)

    assert !s.invalid_description

    l = s.to_list
    assert_equal l.type, :list
    assert_equal l.ar, ['xyz']

    s.value = ''
    assert_equal s.invalid_description, 'empty string'
  end
end
