module Envy
  class CmdRunner
    def initialize(sys, io, builder)
      @sys = sys
      @io = io
      @builder = builder

      @commands = {
        'set' => ->(args) { raw_set(args) },
        'unset' => ->(args) { raw_unset(args) },
        'list-add' => ->(args) { list_add(args) },
        'list-del' => ->(args) { list_del(args) },
        'clean' => ->(args) { clean(args) },
        'path-add' => ->(args) { path_add(args) },
        'path-del' => ->(args) { path_del(args) },
        'path-clean' => ->(args) { path_clean(args) },
      }
    end
    attr_reader :builder

    def set(args)
      raise Envy::Error.new "set requires more arguments. Use 'set <var> <value>'" if args.size < 2
      @builder.set(args[0], args[1..].join(' '))
    end

    def unset(args)
      args.each do |name|
        @builder.unset name
      end
    end

    def do_list_add(name, vals)
      list = @builder.smart_get(name).interactive_to_list(@io)
      vals.each do |val|
        list.insert(val)
      end
      @builder.smart_set(list)
    end

    def list_add(args)
      raise Envy::Error.new "list-add requires more arguments. Use 'list-add <var> <value> [<value>...]'" if args.size < 2
      do_list_add(args[0], args[1..])
    end

    def do_list_del(name, elem)
      list = @builder.smart_get(name).interactive_to_list(@io)

      deleted = if index.to_s == elem
        list.delete_at(index)
      else
        list.delete(elem)
      end

      if deleted
        builder.smart_set(list)
      else
        @io.puts "No item '#{elem}' in #{name}"
      end
    end

    def list_del(args)
      raise Envy::Error.new "list-del requires two arguments. Use 'list-del <var> <value|index>'" if args.size != 2
      do_list_del(args[0], args[1])
    end

    def clean(args)
      args.each do |name|
        var = @builder.smart_get(name)
        var.clean!
        @builder.smart_set(var)
      end
    end

    def path_add(args)
      raise Envy::Error.new "path-add called with nothing to add" if args.empty?
      do_list_add(@sys.path_var_name, args)
    end

    def path_del(args)
      raise Envy::Error.new "path-del requires one argument. Use 'path-del <value|index>'" if args.size != 1
      do_list_del(@sys.path_var_name, args[0])
    end

    def path_clean(args)
      clean([@sys.path_var_name])
    end

    def run_command(cmd, args)
      func = @commands[cmd]
      raise Envy::Error.new "unknown command '#{cmd}'" if !func
      func.(args)
    end
  end
end
