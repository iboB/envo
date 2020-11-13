require_relative '../lib/envo'
require 'test/unit'

include Envo

class TestListVal < Test::Unit::TestCase
  def test_casts
    l = ListVal.new([1, 5, 3, 2, 1])

    assert_equal l.type, :list
    assert l.list?
    assert_same l.to_list, l

    other = ListVal.new([1, 2, 3])
    assert l.accept_assign?(other)

    other = NoVal.new
    assert !l.accept_assign?(other)

    other = StringVal.new('')
    assert !l.accept_assign?(other)

    assert !l.invalid_description

    assert l.accept_item?(42)

    l.ar.clear
    assert_equal l.invalid_description, "empty list"
  end

  def test_ops
    l = ListVal.new([1, 5, 2, 3, 3, 2])

    assert_equal l.ar, [1, 5, 2, 3, 3, 2]
    l.clean!
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
