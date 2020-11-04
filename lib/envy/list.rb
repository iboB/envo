module Envy
  class List
    def self.from_ar(ar)
      @ar = ar.uniq
    end
    def self.from_str(sys, str)
      from_ar(@sys.platform.s_to_a(str))
    end
    attr_reader :ar
    def envy_to_s(sys)
      sys.platform.a_to_s(@ar.map { |v| v.envy_to_s(sys) })
    end
  end
end