module Git

  module Repo
    extend self

    def set_fake_remote
      Dir.mkdir test_repo_url unless Dir.exists? test_repo_url
      `git init --bare #{test_repo_url}`
      `git remote add test #{test_repo_url}`
    end

    def tear_fake_remote
      `git remote remove test`
      FileUtils.rm_rf test_repo_url
    end

    private

    def test_repo_url
     @test_repo_path ||= File.join Maria::Engine.root, '/spec/support/repo'
    end
  end

end
