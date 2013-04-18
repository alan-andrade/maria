module Assetable
  class Base
    # Assetable::Base
    #
    # This class tries to mirror what ActiveRecord::Base does but with a git
    # persistence layer instead of a DB.
    #
    # You need to inherit from this class and always set an asset type.
    #
    # class Pdf < Assetable::Base
    #   asset_type :pdf
    # end
    #
    #
    # What asset_type does, is to find and include that module into the
    # actual object. So you'd need to create the Pdf asset module.
    #
    # module Assetable::Pdf
    #   include Assetable::Template
    #
    #   def asset_type
    #     :pdf
    #   end
    #
    #   def max_size
    #     1.megabytes
    #   end
    #
    #   ...
    #
    # end
    #
    # Its important you load the Assetable::Template so that your module
    # inherits all default behaviour.
    attr_accessor :name, :content, :committer

    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend Assetable::Finders
    extend ActiveModel::Naming

    include FileControl # Persists to disk
    include Git # Persists to git

    validates_presence_of :name, :content, :committer
    validate :content_length # just to avoid the name override

    validates :name, format: { without: /[\s\W]/, message: 'Plase use letters and underscores or hypens'}

    # Creates a new asset object that could be persisted later.
    # You must pass an attributes hash.
    def initialize(attributes={})
      attributes ||= {}
      throw 'Provide and asset type' unless respond_to? :asset_type
      attributes.each{ |k,v| send "#{k}=", v }
    end

    # The asset id will be the name (not the complete name, which includes
    # the file extension)
    #
    # Beware that once the asset has a name, we don't want to change it, unless
    # we really need to.
    def id
      name
    end

    # save
    #
    # This will persist the asset in each layer.
    # FileControl, then Git, and then push to remote repo.
    def save
      if valid?
        write
        stage
        commit
        push
      else
        false
      end
    end

    # update_attributes
    #
    # Actirecords mirror method to update an objects attribute.
    def update_attributes(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
    end

    # to_param
    #
    # This is used by active resource to create the url with the routes helper
    # methods.
    #
    # Whe want the name with no extension.
    def to_param
      if name
        name.gsub(/\..*$/, '')
      else
        ''
      end
    end

    # persisted?
    #
    # Used by form_for to know if we're creating a new instance or we're updating
    # it.
    #
    # our persistence mark is the committed state our file has.
    alias_method :persisted?, :committed?


    # asset_type
    #
    # Necessary method to load asset behaviour.
    def self.asset_type(type=:html)
      base = 'assetable/'
      include (base+type.to_s).camelize.constantize
    end

    def self.base_path
      File.join FileControl.root_path, self.name.demodulize.downcase.pluralize
    end

    private

    # Validating this way feels funky... meh
    def content_length
      ### ___________ -> giak, a bunch of logic here.
      if !content.nil? and content.length > max_size
        errors.add :base, 'Content is too big.'
      end
    end

  end
end
