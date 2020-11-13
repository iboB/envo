require_relative '../lib/envo'
require 'test/unit'

class TestHostShell < Test::Unit::TestCase
  def test_basic
    s = Envo::HostShell
    assert_not_nil s
  end
end
