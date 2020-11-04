$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

require "envy/envy_to_s"

module Envy
  autoload :VERSION,    "envy/version"
  autoload :Platform,   "envy/platform"
  autoload :HostSystem, "envy/host_system"
  autoload :Builder,    "envy/builder"
end
