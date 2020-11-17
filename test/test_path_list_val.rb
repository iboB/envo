require_relative '../lib/envo'
require 'test/unit'

include Envo

class TestPathListVal < Test::Unit::TestCase
  class MockHost
    def self.path_exists?(path)
      path == '/foo/bar'
    end
    def self.path_id(path)
      path_exists?(path) ? path.hash : -1
    end
  end

  def test_casts
    pl = PathListVal.new(MockHost, ['/foo/bar'])

    assert_equal pl.type, :"path list"
    assert pl.list?
    assert_equal pl.ar, ['/foo/bar']

    pl.clean!
    assert_equal pl.ar, ['/foo/bar']

    assert_nil pl.invalid_description

    other = ListVal.new(['xx'])
    assert !pl.accept_assign?(other)

    other = PathListVal.new(MockHost, ['/bar/baz'])
    assert pl.accept_assign?(other)

    other.ar.clear
    assert_equal other.invalid_description, 'empty list'

    item = StringVal.new('xx')
    assert !pl.accept_item?(item)

    item = PathVal.new(MockHost, '/xx')
    assert pl.accept_item?(item)

    toclear = PathListVal.new(MockHost, ['/foo/bar', '/bar/baz', '/something', '/foo/bar'])
    toclear.clean!
    assert_equal toclear.ar, ['/foo/bar']
  end
end
