module Envy
  class ValueWrapper
    def initialize(value)
      @value = value
    end
    def self.from_env_value(sys, str)
      plat = sys.platform
      is_list = plat.likely_list?(str)
      is_path = plat.likely_abs_path?(str)

      if is_list
        ar = plat.v_to_a(str)
        return ValueWrapper.new(ListValue.new(ar))
      else
        return ValueWrapper.new(str)
      end
    end
  end
end
