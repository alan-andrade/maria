#require 'active_support/core_ext/module'
require 'active_support/concern'

module Git

  ALLOWED_ACTIONS = %w(add commit push checkout branch rm)
  MASTER_BRANCH = 'master'

  extend ActiveSupport::Concern

  included do
    include FileControl
  end

  def self.current_branch
    # * master  ->  master
    branches = `git branch`.split
    pointer = branches.index('*')
    branches[pointer+1]
  end

  def commit
    throw 'Implement it man!'
  end

  def stage
    write and Git.add '-f', file_path
    #                 ^^^^ due to gitigonre
  end

  ALLOWED_ACTIONS.each do |action|
    define_singleton_method action do |*args|
      git(action, args)
    end
  end

  private

  def self.git(action, *args)
    command =  "git #{action} #{args.join(' ')}"
    system(command+' 1>/dev/null') or raise StandardError, "Github error when called: #{command}"
  end

end

module Git::Test
  @original_branch = Git.current_branch
  @testing_branch = 'test'

  @original_branch != @testing_branch or raise 'Move out from test branch to continue'

  def self.before
    begin
      Git.branch '-D', @testing_branch
    rescue
    ensure
      Git.checkout '-b', @testing_branch
    end
  end

  def self.after
    begin
      Git.rm '-rf', FileControl::Test.root_path
    rescue
    ensure
      Git.checkout @original_branch
      Git.branch '-D', @testing_branch
    end
  end

  def self.setup
    raise 'Install or require RSpec before using this.' unless defined? RSpec
    Rspec.configure do |c|
      c.before(:each){ Git::Test.before if example.example_group.metadata[:git] }
      c.after(:each){ Git::Test.after if example.example_group.metadata[:git] }
    end # /rspec
  end # /setup

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
