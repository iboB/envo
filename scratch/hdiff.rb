class Hash
  def subhash_at_keys(ar_keys)
    ar_keys.zip(self.values_at(*ar_keys)).to_h
  end
end

def hdiff(old, new)
  ok = old.keys
  nk = new.keys

  removed_keys = ok - nk
  preserved_keys = ok - removed_keys

  changes = old.subhash_at_keys(preserved_keys).merge(new) { |k, ov, nv|
    ov == nv ? nil : nv
  }.compact

  {unset: removed_keys, set: changes}
end

p hdiff({'x': 1, 'y': 2, 'z': 3}, {'x': 1, 'y': 5, 'w': 4})
