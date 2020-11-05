require_relative '../lib/envy/list_var.rb'
require 'test/unit'

include Envy

class TestListVar < Test::Unit::TestCase
  def test_basic
    l = ListVar.new(nil, nil, [1, 5, 2, 3, 3, 2])

    assert_equal l.ar, [1, 5, 2, 3, 3, 2]
    l.uniq!
    assert_equal l.ar, [1, 5, 2, 3]
    l.insert(8)
    assert_equal l.ar, [1, 5, 2, 3, 8]
    l.insert(8)
    assert_equal l.ar, [1, 5, 2, 3, 8]
    l.insert(8, :front)
    assert_equal l.ar, [8, 1, 5, 2, 3]
    l.insert(8)
    assert_equal l.ar, [8, 1, 5, 2, 3]
    l.insert(5)
    assert_equal l.ar, [8, 1, 5, 2, 3]
    l.insert(8, :back)
    assert_equal l.ar, [1, 5, 2, 3, 8]
    l.insert(5, :front)
    assert_equal l.ar, [5, 1, 2, 3, 8]
    l.insert(10, :front)
    assert_equal l.ar, [10, 5, 1, 2, 3, 8]

    l.delete(1)
    assert_equal l.ar, [10, 5, 2, 3, 8]
    l.delete(8)
    assert_equal l.ar, [10, 5, 2, 3]
  end
end
