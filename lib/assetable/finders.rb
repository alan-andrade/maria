module Assetable

  # Interface to find any asset.
  #
  # You need extend this in you base class so that you can do the following.
  #
  # class Base; extend AssetableFinders' end
  #
  # Base.all #=> [BaseObject, BaseObject]
  #
  # Base.find(name:'foo') #=> BaseObject(name: 'foo.ext')
  #
  #
  # This assumes you have FileControl included in you class.
  module Finders

    def all
      list.map{|f| self.new basename: f }
    end

    # this methods feels too weak and wrong.
    def find(basename)
      list.include?(basename) ?
        self.read_from_disk(basename) :
        throw('Not Found')
    end

    private

    def list
      `ls #{base_path}`.split(/\n/).map{|f| f.gsub(/\..*$/, '') }
    end

  end
end
