require 'active_support/concern'
#require 'active_support/core_ext/module'


#
# FileControl Module
#
# FileControl will let any class be written down to disk using
# write and read.
#
# You're class needs to have 2 instance methods though.
#   NAME and CONTENT
#
# Name is taken to name the file
# Content is the body or content of the file
#
# You can use it like this:
#
#
# class TXT
#   attr_accessor :name, :content
#   include FileControl
# end
#
# txt = TXT.new
# txt.name 'ohman.txt'
# txt.content 'This is an email that will be sent to everyone'
# txt.write
#   # => true
#
# txt.read
#   # => 'This is an email that will be sent to everyone'
#
#
# =====================================================
#
# Configuration
#
# Before you use FileControl, you need to set the root_path
# into which files will be stored.
#
# i.e.
#
# FileControl.root_path = '/dev/tmp'
#
# Otherwise, and exception will be thrown
#
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

    # root_path=
    #
    # sets the root_path for FileControl validating the existence of the same.
    #
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

    # remove_all!
    #
    # You'll use this method in the tests. This will delete every file
    # that has been written under the root_path.
    #
    # Be careful, you can loose important data.
    def remove_all!
      Dir.entries(root_path).reject{|f| File.directory?(f) }.each do |f|
        File.delete File.join root_path, f
      end
    end

    # reset
    #
    # You will use this method in tests to reset the value of root_path.
    # Since the setter of this attribute has validations, we need a way
    # to get our Module to an `initial state`.
    def reset
      @root_path = nil
    end
  end

  # Instance methods for class which included this.

  # base_path
  #
  # Return the complete path including the name of the file.
  def base_path
    File.join FileControl.root_path, name
  end

  # write
  #
  # Writes the content of the class under the 'content' attribute to a file
  # named as the 'name' attribute.
  #
  # Returns true or false depending if the writting was successful.
  def write
    File.open base_path, 'w+' do |f|
      f.write content
    end
  end

  # read
  #
  # Reads the content of the file if it has been written down previously.
  # Otherwise, will return NIL.
  #
  # Discuss about throwing errors or return nil.
  #
  def read
    written_down? ?
      File.open(base_path).read :
      nil
  end

  # written_down?
  #
  # The instance is in the disk yet?
  #
  def written_down?
    File.exists? base_path
  end

end
