module Assetable
  module Template
    %w(asset_type extension max_size).each{|m|
      define_method m do
        throw "Implement #{m}"
      end
    }
  end
end
