require_relative '../lib/envy/envy_to_s'
require 'test/unit'

class TestEnvyToS < Test::Unit::TestCase
  def test_types
    assert_equal 5.envy_to_s(nil), '5'
    assert_equal 'asd'.envy_to_s(nil), 'asd'
    assert_equal 3.14.envy_to_s(nil), 3.14.to_s
  end
end