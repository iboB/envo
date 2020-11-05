$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION,        "envy/version"
  autoload :Platform,       "envy/platform"
  autoload :System,         "envy/system"
  autoload :ListValue,      "envy/list_value"
  autoload :ValueWrapper,   "envy/value_wrapper"
  # autoload :AbsPathValue,   "envy/abs_path_value"
  autoload :HostSystem,     "envy/host_system"
  autoload :Builder,        "envy/builder"
end
