module Envy
  class AbsPathListVar < ListVar
    def attribs(elem)
      super + (@sys.path_exists?(elem) ? ' ' : 'N')
    end
    def insert(elem, pos=nil)
      plat = @sys.platform
      elem = plat.fix_path(elem)
      if !plat.likely_abs_path?(elem)
        elem = File.join(plat.fix_path(Dir.pwd), elem)
      end
      super
    end
  end
end
