module Assetable
  require 'active_support/core_ext/numeric'
  require 'active_model'
  require 'assetable/finders'
  require 'assetable/base'

  #%w(basic dummy html dummy_binary image).each do |f|
    #require "assetable/asset_types/#{f}.rb"
  #end
  require 'assetable/asset_types/basic'
  require 'assetable/asset_types/binary_base'
  require 'assetable/asset_types/dummy'
  require 'assetable/asset_types/dummy_binary'
  require 'assetable/asset_types/html'
  require 'assetable/asset_types/image'

end
