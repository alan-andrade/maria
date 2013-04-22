module Assetable

  module DummyAsset
    extend BasicAsset

    def asset_type
      :dummy
    end

    def max_size
      5.bytes
    end

    def extension
      'dummyext'
    end

  end
end
