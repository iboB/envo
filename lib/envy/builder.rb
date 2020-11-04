module Envy
  class Builder
    def initialize(system)
      @sys = system
      @real_env = @sys.env

      # if @real_env is ENV, we can use to_h to clone it into the work env
      # however it can be an actual hash in which case to_h will return the same one
      # and we would have to use clone
      # so to make this work in all cases we preform a manual shallow copy
      @work_env = @real_env.map { |k, v| [k, v] }.to_h
    end

    def set(var, val)
      @work_env[var] = val
    end

    def get(var, val)
      @work_env[var]
    end

    def unset(var)
      @work_env.delete(var)
    end

    class Patch
      def initialize(removed, changed, added)
        @removed = removed
        @changed = changed
        @added = added
      end

      attr_reader :removed, :changed, :added
    end

    def diff
      real_vars = @real_env.keys
      work_vars = @work_env.keys

      removed_vars = real_vars - work_vars
      added_vars = work_vars - real_vars
      preserved_vars = real_vars - removed_vars

      changed = preserved_vars.map { |v|
        r = @real_env[v]
        w = @work_env[v]

        r == w.envy_to_s(@sys) ? nil : [v, w]
      }.compact.to_h

      added = added_vars.map { |v| [v, @work_env[v]] }.to_h

      Patch.new(removed_vars, changed, added)
    end

    attr_reader :real_env, :work_env
  end
end
