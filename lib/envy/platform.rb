module Envy
  module Platform
    module PCommon
      def env
        ENV
      end
      def a_to_v(a)
        a.join(list_sep)
      end
      def v_to_a(v)
        v.split(list_sep)
      end
    end

    class Windows
      extend PCommon
      def self.name
        'Windows'
      end
      LIST_SEP = ';'
      def self.list_sep
        LIST_SEP
      end
      def self.cmd_set(var, value)
        "set #{var}=#{value}"
      end
      def self.cmd_unset(var)
        "set #{var}="
      end
      def self.likely_absolute_path?(val)
        val =~ /^[a-zA-Z]\:\\/
      end
      def self.likely_list?(val)
        val.include?(LIST_SEP)
      end
    end

    class UnixLike
      extend PCommon
      def self.name
        'UnixLike'
      end
      LIST_SEP = ':'
      def self.list_sep
        LIST_SEP
      end
      def self.cmd_set(var, value)
        "export #{var}=#{value.to_s.inspect}"
      end
      def self.cmd_unset(var)
        "unset -v #{var}"
      end
      def self.likely_absolute_path?(val)
        !val.empty? && val[0] == '/'
      end
      def self.likely_list?(val)
        # we have more work
        # if the value includes our list separtor ":", we need to make sure whether a url:port combination is not a better fit
        return false if !val.include?(LIST_SEP)

        sep_cnt = val.count(LIST_SEP)
        return true if sep_cnt > 2

        # match scheme://url
        return false if val =~ /^\w+\:\/\//

        return true if sep_cnt == 2 # everything else with 2 separators is a list

        # match diplay type strings address:0.0
        return false if val =~ /\:0.0$/

        # match something:number
        !(val =~ /.*\:\d+$/)
      end
    end
  end
end
