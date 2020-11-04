require_relative '../lib/envy'
require 'test/unit'

class TestHostSystem < Test::Unit::TestCase
  S = Envy::HostSystem
  def test_basic
    assert S.platform.name == 'Windows' || S.platform.name == 'UnixLike'
  end
end
