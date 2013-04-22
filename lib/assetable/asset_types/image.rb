module Assetable

  module ImageAsset
    include BinaryBase

    def asset_type
      :image
    end

    def max_size
      5.megabytes
    end

    def extension
      'png'
    end

  end

end
