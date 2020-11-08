module Envy
  class AbsPathListVar < ListVar
    def attribs(elem)
      super + (@sys.path_exists?(elem) ? ' ' : 'N')
    end
    def insert(elem, pos=nil)
      plat = @sys.platform
      elem = plat.fix_path(elem)
      if !plat.likely_abs_path?(elem)
        elem = plat.fix_path(File.join(Dir.pwd, elem))
      end
      super
    end
    def clean!
      super
      @ar.select! { |elem| @sys.path_exists?(elem) }
    end
  end
end
