require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestListVar < Test::Unit::TestCase
  def test_basic
    l = ListVal.new([1, 5, 2, 3, 3, 2])

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
    l.insert(4)
    assert_equal l.ar, [10, 5, 2, 3, 4]
    l.delete_at(1)
    assert_equal l.ar, [10, 2, 3, 4]

    assert_equal l.shift(10, :back), 3
    assert_equal l.ar, [2, 3, 4, 10]
    assert_equal l.shift(10, :back), 3
    assert_equal l.ar, [2, 3, 4, 10]
    assert_equal l.shift(3, :up), 0
    assert_equal l.ar, [3, 2, 4, 10]
    assert_equal l.shift(3, :up), 0
    assert_equal l.ar, [3, 2, 4, 10]
    assert_equal l.shift(2, :down), 2
    assert_equal l.ar, [3, 4, 2, 10]
    assert_equal l.shift(10, :down), 3
    assert_equal l.ar, [3, 4, 2, 10]
    assert_equal l.shift(2, :front), 0
    assert_equal l.ar, [2, 3, 4, 10]
    assert_equal l.shift(2, :front), 0
    assert_equal l.ar, [2, 3, 4, 10]
  end
end
