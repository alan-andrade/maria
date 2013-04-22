module Assetable
  module DummyBinaryAsset
    include BinaryBase

    def asset_type
      :dummy_binary
    end

    def extension
      'png'
    end

    def max_size
      5.megabytes
    end

  end
end
