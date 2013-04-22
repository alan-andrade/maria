module Assetable
  require 'active_support/core_ext/numeric'
  require 'active_model'
  require 'assetable/finders'
  require 'assetable/base'

  #%w(basic dummy html dummy_binary image).each do |f|
    #require "assetable/asset_types/#{f}.rb"
  #end
  Dir.chdir 'lib'
  Dir["assetable/asset_types/*.rb"].each{|f| require f }
  Dir.chdir '..'
end
