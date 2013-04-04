require 'active_support/concern'
#require 'active_support/core_ext/module'

module FileControl
  class ConfigurationError < StandardError; self; end
  class RequiredAttributes < StandardError; self; end

  extend ActiveSupport::Concern

  included do
    FileControl.root_path? or raise ConfigurationError, 'Please set a root_path for FileControl'
    # Is there a better way to check instance methods ?
    unless  instance_methods(false).include?(:name) and
            instance_methods(false).include?(:content)
      raise RequiredAttributes, "Please make sure #{self.class.name} responds to :name and :content"
    end
  end

  class << self
    def root_path= dirname
      unless Dir.exists?(dirname)
        raise ConfigurationError,
          "The dirname #{dirname} doesn't exist, please provide a real one."
      end
      @root_path = dirname
    end

    def root_path
      @root_path
    end

    def root_path?
      !@root_path.nil?
    end

    def remove_all!
      Dir.entries(root_path).reject{|f| File.directory?(f) }.each do |f|
        File.delete File.join root_path, f
      end
    end

    def reset
      @root_path = nil
    end
  end

  # Instance methods for class which included this.

  def base_path
    File.join FileControl.root_path, name
  end

  def write
    File.open base_path, 'w+' do |f|
      f.write content
    end
  end

  def read
    written_down? ?
      File.open(base_path).read :
      nil
  end

  def written_down?
    File.exists? base_path
  end

end
