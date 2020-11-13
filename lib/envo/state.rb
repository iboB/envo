module Envo
  class State
    def initialize(env)
      @real_env = env.to_h
      @work_env = nil
    end

    attr_reader :real_env

    def set(name, val)
      if val == nil
        unset(name)
      else
        work_env[name] = val.to_s
      end
    end

    def unset(name)
      work_env.delete(name)
    end

    def get(name)
      work_env[name]
    end

    def work_env
      return @work_env if @work_env
      # if @real_env is ENV, we can use to_h to clone it into the work env
      # however it can be an actual hash in which case to_h will return the same one
      # and we would have to use clone
      # so to make this work in all cases we preform a manual shallow copy
      @work_env = @real_env.map { |k, v| [k, v] }.to_h
    end

    class Patch
      def initialize(removed = [], changed = {}, added = {})
        @removed = removed
        @changed = changed
        @added = added
      end

      def empty?
        @removed.empty? && @changed.empty? && @added.empty?
      end

      attr_reader :removed, :changed, :added
    end

    def diff
      return Patch.new if !@work_env

      real_names = @real_env.keys
      work_names = @work_env.keys

      removed_names = real_names - work_names
      added_names = work_names - real_names
      preserved_names = real_names - removed_names

      changed = preserved_names.map { |v|
        r = @real_env[v]
        w = @work_env[v]

        r == w ? nil : [v, w]
      }.compact.to_h

      added = added_names.map { |v| [v, @work_env[v]] }.to_h

      Patch.new(removed_names, changed, added)
    end
  end
end
