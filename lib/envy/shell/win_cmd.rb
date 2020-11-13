module Envy
  module Shell
    module WinCmd
      extend self

      def installer
        Cli::InstallerWinCmd
      end

      def path_var_name
        'Path'
      end
      def home_var_name
        'HOME'
      end

      def likely_abs_path?(val)
        val =~ /^[a-zA-Z]\:\\/
      end
      def likely_rel_path?(val)
        return !val.empty? && val[0] == '.'
      end
      def fix_path(path)
        path.gsub('/', '\\')
      end

      LIST_SEP = ';'
      def likely_list?(val)
        val.include?(LIST_SEP)
      end
      def list_to_ar(list)
        list.split(LIST_SEP)
      end
      def ar_to_list(ar)
        ar.join(LIST_SEP)
      end

      def cmd_set_env_var(name, value)
        escaped = value # TODO
        "set #{name}=#{escaped}"
      end
      def cmd_unset_env_var(name)
        "set #{name}="
      end
    end
  end
end
