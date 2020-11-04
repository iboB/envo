POS_FRONT = -1
POS_BACK = 1

class EnvChange
  module H
    def make_list(val)
      return val if val.class != String
      val.split(Platform.list_sep)
    end

    def add_to_list(list, val, pos = nil)
      # assume unique elements
      old_index = list.index(val)
      new_index = case pos
        when POS_FRONT then 0
        when POS_BACK then -1
        else old_index
      end

      return list << val if !new_index
      return list if new_index == old_index
      return list.insert(new_index, val) if !old_index

      # we need to reorder
      list.delete_at(old_index)
      list.insert(new_index, val)
    end

    def self.subhash_at_keys(h, keys)
      keys.zip(h.values_at(*keys)).to_h
    end
  end

  def initialize
    @old_env = ENV
    @new_env = ENV.to_h
  end

  def apply
    ok = @old_env.keys
    nk = @new_env.keys

    removed_keys = ok - nk
    preserved_keys = ok - removed_keys

    changes = H.subhash_at_keys(@old_env, preserved_keys).merge(@new_env) { |k, ov, nv|
      ov == nv ? nil : nv
    }.compact

    removed_keys.each do |k|
      puts "unset #{k}"
    end

    changes.each do |k, v|
      puts "set #{k}=#{v}"
    end

    @old_env = @new_env.clone
  end

  def set(var, val)
    @new_env[var] = val
  end

  def unset(var)
    @new_env.delete var
  end

  def dedup_list(var)
    @new_env[var] = H.make_list(@new_env[var]).uniq
  end

  def add_to_list(var, val, pos = nil)
    list = dedup_list(var)
    @new_env[var] = H.add_to_list(list, val, pos)
  end

  def remove_from_list(var, val)
    list = dedup_list(var)
    list.delete(val)
    @new_env[var] = list
  end
end

e = EnvChange.new

e.set('PATH', 'asd')

e.apply
