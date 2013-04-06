#require 'active_support/core_ext/module'
require 'active_support/concern'

module Git

  ALLOWED_ACTIONS = %w(add commit push checkout)
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

  def add
    git :add, filepath
  end

  def commit
    throw 'Implement it man!'
  end

  ALLOWED_ACTIONS.each do |action|
    define_singleton_method action do |*args|
      git(action, args)
    end
  end

  private

  def self.git(action, *args)
    command =  "git #{action} #{args.join(' ')}"
    system(command+' 1>/dev/null') or raise 'Github error'
  end

end

module Git::Test
  @original_branch = Git.current_branch
  @testing_branch = 'test'

  @original_branch != @testing_branch or raise 'Move out from test branch to continue'

  def self.before
    Git.checkout @testing_branch
  end

  def self.after
    Git.checkout @original_branch
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
