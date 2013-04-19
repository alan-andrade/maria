module Assetable

  module HtmlAsset
    include BasicAsset

    def asset_type
      :html
    end

    def max_size
      500.kilobytes
    end

    def extension
      'html'
    end
  end

end
