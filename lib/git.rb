require 'active_support/core_ext/module'
require 'active_support/concern'

module Git
  mattr_accessor :username

  module Persistence

    def persisted?
      # file written, added, commited, pushed
      false
    end

  end

  module Attributes
    extend ActiveSupport::Concern

    included do
      attr_reader :body, :name
    end

  end

  module Base
    def name
      ''
    end

    def body
      ''
    end
  end

end



# Page:
#   default extension -> html
#   name
#
# assets/
#   pages/
#   stylesheets/
#   images/
#   mp3/
#   ogg/

#class StaticAsset
#end

#class DynamicAsset
#end

#class Asset
  #def path
    #throw NotYetImplemented
  #end
#end

#class Page < Asset
#end

#class Page
  #include Assetify::Static
  #include Assetify::Dynamic

  #include Git::Persistence
#end

#class CSS
  #include Assetify
#end
