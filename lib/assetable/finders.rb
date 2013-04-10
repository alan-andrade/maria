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
      `ls #{base_path}`.split.map do |f|
        unless File.directory?(f)
          Maria::Page.new(name: f)
        end
      end
    end

  end
end
