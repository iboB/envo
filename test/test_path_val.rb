require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestPathVal < Test::Unit::TestCase
  class MinSys
    def self.path_exists?(path)
      path == '/foo/bar'
    end
  end

  def test_casts
    pv = PathVal.new(MinSys, '/foo/bar')

    assert_equal pv.type, :path
    assert !pv.list?

    assert_nil pv.invalid_description

    other = StringVal.new('xx')
    assert !pv.accept_assign?(other)

    other = PathVal.new(MinSys, '/bar/baz')
    assert pv.accept_assign?(other)
    assert_equal other.invalid_description, 'non-existing path'

    l = pv.to_list
    assert_equal l.type, :"path list"
    assert_equal l.ar, ['/foo/bar']
  end
end
