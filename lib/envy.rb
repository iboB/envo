$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION, "envy/version"

  autoload :NoVal,      "envy/val/no_val"
  autoload :StringVal,  "envy/val/string_val"

  autoload :State,   "envy/state"
end
