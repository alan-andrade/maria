module Assetable

  class HtmlAsset < BasicAsset

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
