$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "maria/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "maria"
  s.version     = Maria::VERSION
  s.authors     = ["Alan Andrade"]
  s.email       = ["aandrade@marqeta.com"]
  s.homepage    = "http://marqeta.com"
  s.summary     = "CMS-like tool"
  s.description = "Very cool things that will make developers and designers happy."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["rspec/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_development_dependency 'rspec-rails'
end
