$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION,      "envy/version"
  autoload :Platform,     "envy/platform"
  autoload :System,       "envy/system"
  autoload :NoVar,        "envy/no_var"
  autoload :StringVar,    "envy/string_var"
  autoload :ListVar,      "envy/list_var"
  autoload :VarBuilder,   "envy/var_builder"
  autoload :HostSystem,   "envy/host_system"
  autoload :Error,        "envy/error"
  autoload :Builder,      "envy/builder"
end
