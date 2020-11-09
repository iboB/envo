require_relative '../lib/envy'
require 'test/unit'

class TestHostShell < Test::Unit::TestCase
  def test_basic
    s = Envy::HostShell
    assert_not_nil s
  end
end
