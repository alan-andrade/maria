module Assetable
  module Html
    include Assetable::Template

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
