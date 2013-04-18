module Assetable
  require 'active_support/core_ext/numeric'
  require 'active_model'
  require 'assetable/finders'
  require 'assetable/base'

  %w(basic dummy html).each do |f|
    require "assetable/asset_types/#{f}.rb"
  end
end
