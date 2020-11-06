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
    module IOCommon
      def initialize
        @output = []
      end
      def log_and_exec(cmd)
        puts(cmd)
        @output << cmd
      end
      def output
        @output.join("\n")
      end
    end

    class Windows
      extend PCommon
      def self.type
        :Windows
      end
      LIST_SEP = ';'
      def self.list_sep
        LIST_SEP
      end
      def self.likely_abs_path?(val)
        val =~ /^[a-zA-Z]\:\\/
      end
      def self.fix_path(path)
        path.gsub('/', '\\')
      end
      def self.likely_list?(val)
        val.include?(LIST_SEP)
      end

      class Batch
        include IOCommon

        def puts(str)
          @output += str.lines.map { |l| "echo #{l.chomp}" }
        end
        def error(str)
          @output += str.lines.map { |l| "echo #{l.chomp} 1>&2"}
        end
        def set_env_var(name, value)
          log_and_exec("set #{name}=#{value}")
        end
        def unset_env_var(name)
          log_and_exec("set #{name}=")
        end
      end
      def self.make_io
        Batch.new
      end
    end

    class UnixLike
      extend PCommon
      def self.type
        :UnixLike
      end
      LIST_SEP = ':'
      def self.list_sep
        LIST_SEP
      end
      def self.likely_abs_path?(val)
        !val.empty? && val[0] == '/'
      end
      def self.fix_path(path)
        path
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

        # match display type strings address:digit.digit
        return false if val =~ /\:\d.\d$/

        # match something:number to be interpreted as addr:port
        !(val =~ /.*\:\d+$/)
      end

      class Sh
        include IOCommon

        def puts(str)
          @output += str.lines.map { |l| "echo #{l.chomp.inspect}" }
        end
        def error(str)
          @output += str.lines.map { |l| ">&2 echo #{l.chomp.inspect}" }
        end
        def set_env_var(name, value)
          log_and_exec("export #{name}=#{value.to_s.inspect}")
        end
        def unset_env_var(name)
          log_and_exec("unset -v #{name}")
        end
      end
      def self.make_io
        Sh.new
      end
    end
  end
end
