module Assetable
  class Base
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

    def initialize(attributes={})
      attributes ||= {} # avoid nil, ugly though :'(
      throw 'Provide and asset type' unless respond_to? :asset_type
      attributes.each{ |k,v| send "#{k}=", v }
    end

    def id
      name
    end

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

    def update_attributes(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
    end

    def to_param
      name.gsub(/\..*$/, '')
    end

    alias_method :persisted?, :committed?

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
