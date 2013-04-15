module Maria
  class Engine < ::Rails::Engine
    isolate_namespace Maria

    config.autoload_paths << File.join(Engine.root, "lib")

    config.generators do |g|
      g.test_framework  :rspec
    end

    require 'file_control'
    if Rails.env.test? or Rails.env.development?
      ::FileControl.root_path = Engine.root + 'app/views'
    end

  end
end
