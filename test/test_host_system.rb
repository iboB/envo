require_relative '../lib/envy'
require 'test/unit'

class TestHostSystem < Test::Unit::TestCase
  S = Envy::HostSystem
  def test_basic
    assert S.platform.type == :Windows || S.platform.type == :UnixLike
    assert S.path_var_name.upcase == 'PATH'
  end
end
