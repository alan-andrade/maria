require 'active_support/concern'

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
# FileControl.root_path = '.'
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
#   # written under `root_path`/txt/ohman.txt
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

    # reset
    #
    # You will use this method in tests to reset the value of root_path.
    # Since the setter of this attribute has validations, we need a way
    # to get our Module to an `initial state`.
    def reset
      @root_path = nil
    end
  end

  # remove_all!
  #
  # You'll use this method in the tests. This will delete every file
  # that has been written under the root_path.
  #
  # Be careful, you can loose important data.
  remove_files = ->(dir){
    base_dir = dir
    Dir.entries(dir).reject{|f| File.directory?(f) }.each do |f|
      path = File.join base_dir, f
      File.directory?(path) ?
        remove_files.(path) :
        File.delete(path)
    end
  } # you shoul never be able to call this from the outside. thats why this way.

  define_singleton_method :remove_all! do
    remove_files.(root_path)
  end


  def base_path
    File.join FileControl.root_path, subdir
  end

  # file_path
  #
  # Return the complete path including the name of the file.
  def file_path
    File.join base_path ,name
  end

  # write
  #
  # Writes the content of the class under the 'content' attribute to a file
  # named as the 'name' attribute.
  #
  # Returns true or false depending if the writting was successful.
  def write
    create_subdirs
    File.open file_path, 'w+' do |f|
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
    written? ?
      File.open(file_path).read :
      nil
  end

  # written?
  #
  # The instance is in the disk yet?
  #
  def written?
    File.exists? file_path
  end

  private

  # Takes the class name as a subdir
  def subdir
    self.class.to_s.downcase
  end

  def create_subdirs
    Dir.mkdir(base_path) unless Dir.exists?(base_path)
  end

end

# Test module that will take care of setting up everything
# needed to run the tests.
module FileControl::Test
  def self.setup
    test_dir = Maria::Engine.root.join 'spec', '.tmp'
    Dir.mkdir(test_dir) unless Dir.exists?(test_dir)
  end

  def self.root_path
    File.join(Maria::Engine.root, 'spec/.tmp')
  end
end
