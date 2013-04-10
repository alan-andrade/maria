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
      puts "Base path: #{base_path}"
      files = `ls #{base_path}`
      puts "Files: #{files}"
      files.split
    end

  end
end
