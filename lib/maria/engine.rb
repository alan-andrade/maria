module Maria
  class Engine < ::Rails::Engine
    isolate_namespace Maria
  end
end
