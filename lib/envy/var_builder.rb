module Envy
  class VarBuilder
    def self.build(sys, name, str)
      return NoVar.new(name) if !str

      plat = sys.platform
      is_list = plat.likely_list?(str)
      is_path = plat.likely_abs_path?(str)

      if is_list
        ar = plat.v_to_a(str)
        return ListVar.new(name, plat, ar)
      else
        return StringVar.new(name, str)
      end
    end
  end
end
