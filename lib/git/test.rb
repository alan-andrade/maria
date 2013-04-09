require 'git'

module Git
  module Test

    @original_branch = Git.branch.current
    @testing_branch = 'test'

    @original_branch != @testing_branch or throw 'Move out from test branch to continue'

    def self.before
      Git.branch.force_switch_to @testing_branch
    end

    def self.after
      begin
        Git::Run.run(:rm, '-rf', FileControl::Test.root_path) if has_testing_files?
      rescue
      ensure
        Git.branch.switch_to @original_branch
        Git.branch.delete @testing_branch
      end
    end

    def self.has_testing_files?
      Git::Run.exec('ls-files', FileControl::Test.root_path).split(/\n/).any?
    end

    def self.setup
      raise 'Install or require RSpec before using this.' unless defined? RSpec
      RSpec.configure do |c|
        c.before(:each){ Git::Test.before if example.example_group.metadata[:git] }
        c.after(:each){ Git::Test.after if example.example_group.metadata[:git] }
      end # /rspec
    end # /setup

  end #/test
end
