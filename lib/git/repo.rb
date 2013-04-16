module Git
  module Repo
    extend self
    # Repo
    #
    # Tools for creating fake repos.
    #
    # Helpful when we want to run things in different environments.

    def set_fake_remote
      Dir.mkdir test_repo_url unless Dir.exists? test_repo_url
      `git init --bare #{test_repo_url}`
      `git remote add test #{test_repo_url}`
    end

    def tear_fake_remote
      `git remote remove test`
      FileUtils.rm_rf test_repo_url
    rescue
      puts 'Meh, no fake remote was set. Keep going...'
    end

    private

    def test_repo_url
     @test_repo_path ||= File.join Maria::Engine.root, '/spec/support/repo'
    end
  end

end
