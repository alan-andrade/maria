require 'active_support/core_ext/string/inflections'

module Git

  def stage
    write
    Git::Run.run :add, '-f', file_path
  end

  def status
    Git::Status.get(file_path)
  end

  def self.method_missing(name, *args, &block)
    namespace = 'git/'
    module_string = namespace + name.to_s
    module_string.camelize.constantize
  rescue
    super(name, *args, &block)
  end
end

require 'git/run'
require 'git/branch'
require 'git/status'
require 'git/test'
