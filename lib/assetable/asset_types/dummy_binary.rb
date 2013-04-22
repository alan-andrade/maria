module Assetable
  module DummyBinaryAsset
    include Assetable::BasicAsset

    def asset_type
      :dummy_binary
    end

    def extension
      'png'
    end

    def content
      @content.unpack('H*')
    end

    def max_size
      5.megabytes
    end

  end
end
