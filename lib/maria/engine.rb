module Maria
  class Engine < ::Rails::Engine
    isolate_namespace Maria

    config.autoload_paths << File.join(Engine.root, "lib")

    config.generators do |g|
      g.test_framework  :rspec
    end

    # Might be moved to environments/(test/prod/dev).rb
    unless Rails.env.test?
      FileControl.root = Engine.root
    end

  end
end
