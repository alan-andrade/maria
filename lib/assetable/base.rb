module Assetable
  class Base
    attr_accessor :name, :content, :committer

    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    include FileControl
    include Git

    validates_presence_of :name, :content, :committer
    validate :content_integrity # just to avoid the name override

    def initialize(attributes={})
      throw 'Provide and asset type' if asset_type.nil?
      attributes.each{ |k,v| send "#{k}=", v }
    end

    def self.asset_type(type=:html)
      base = 'assetable/'
      include (base+type.to_s).camelize.constantize
    end

    private

    def content_integrity
      if content.nil? or content.empty?
        errors.add :base, 'Content cant be blank.'
      elsif content.length > max_size
        errors.add :base, 'Content is too big.'
      end
    end

  end
end
