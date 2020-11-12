require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestNoVal < Test::Unit::TestCase
  def test_casts
    n = NoVal.new

    assert_equal n.type, :empty
    assert !n.list?
    assert_nil n.to_env_s

    assert n.accept_assign?(5)

    assert !n.invalid_description

    l = n.to_list
    assert_equal l.type, :list
    assert_empty l.ar

    assert_empty n.to_s
  end
end
