module Maria
  class Engine < ::Rails::Engine
    isolate_namespace Maria

    config.autoload_paths << File.join(Engine.root, "lib")

    config.generators do |g|
      g.test_framework  :rspec
    end

    require 'file_control'
    require 'git'
    require 'assetable'

    Git.root = Maria::Engine.root

    # Keep and eye on this line, it might be better to store them somwhere else.
    ::FileControl.root_path = Engine.root + 'app/views'

    if Rails.env.test? or Rails.env.development?
      require 'git/test'
      Git::Repo.tear_fake_remote
      Git::Repo.set_fake_remote
      Git::Test.set_fake_remote_branches
    else
      Git::Repo.set_real_remote
      Git.remote = 'origin'
      Git.remote_url = "remotes/origin/#{Git::Branch.current}"
    end

  end
end
