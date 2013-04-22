module Assetable
  module BinaryBase
    include BasicAsset

    def file=(tempfile)
      @content = tempfile.read
    end

    def content
      @content.unpack('H*')
    end

  end
end
