require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestPathVal < Test::Unit::TestCase
  class MockHost
    def self.path_exists?(path)
      path == '/foo/bar'
    end
  end

  def test_casts
    pv = PathVal.new(MockHost, '/foo/bar')

    assert_equal pv.type, :path
    assert !pv.list?
    assert_equal pv.path, '/foo/bar'
    assert_same pv.path, pv.to_s
    pv.clean!
    assert_equal pv.path, '/foo/bar'

    assert_nil pv.invalid_description

    other = StringVal.new('xx')
    assert !pv.accept_assign?(other)

    other = PathVal.new(MockHost, '/bar/baz')
    assert pv.accept_assign?(other)
    assert_equal other.invalid_description, 'non-existing path'

    l = pv.to_list
    assert_equal l.type, :"path list"
    assert_equal l.ar, ['/foo/bar']

    other.clean!
    assert_nil other.path
  end
end
