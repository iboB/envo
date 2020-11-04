$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

require "envy/envy_to_s.rb"
require "envy/platform.rb"

module Envy
  autoload :VERSION, "envy/version"
  autoload :Builder, "envy/builder.rb"
end
