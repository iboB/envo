require_relative '../lib/envy'
require 'test/unit'

include Envy

class TestParsedCmd < Test::Unit::TestCase
  def test_basic
    a = ParsedCmd.new(123, [:a, :b])
    assert_equal a.cmd, 123
    assert_equal a.opts, [:a, :b]

    b = ParsedCmd.new(a, [:c])
    assert_equal b.cmd, 123
    assert_equal b.opts, [:c, :a, :b]
  end
end
