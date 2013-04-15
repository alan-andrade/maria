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
      list.split(/\n/).map{|f| self.new name: f }
    end

    # this methods feels too weak and wrong.
    def find(name)
      list.include?(name) ?
        self.new(name: name) :
        nil
    end

    private

    def list
      `ls #{base_path}`
    end

  end
end
