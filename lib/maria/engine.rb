module Maria
  class Engine < ::Rails::Engine
    isolate_namespace Maria

    config.autoload_paths << File.join(Engine.root, "lib")

    config.generators do |g|
      g.test_framework  :rspec
    end

    # Might be moved to environments/(test/prod/dev).rb
    require 'file_control'
    unless Rails.env.test?
      ::FileControl.root_path = Engine.root + 'app/views'
    end

    require 'git'

    unless Rails.env.production? or Rails.env.staging?
      Git::Repo.set_fake_remote
      Git.remote = 'test'
      Git.remote_url = 'remotes/test'
    else
      Git.remote = 'origin'
      Git.remote_url = 'remotes/origin'
    end

  end
end
