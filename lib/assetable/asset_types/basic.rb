module Assetable

  module BasicAsset
    METHODS = %w(asset_type extension max_size).freeze

    %w(asset_type extension max_size).each{|m|
      define_method m do
        throw "Implement #{m}"
      end
    }
  end

end
