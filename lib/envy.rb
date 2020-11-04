$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION,    "envy/version"
  autoload :Platform,   "envy/platform"
  autoload :System,     "envy/system"
  autoload :HostSystem, "envy/host_system"
  autoload :Builder,    "envy/builder"
end
