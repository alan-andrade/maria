require 'active_support/core_ext/string/inflections'

module Git

  def status
    Git::Status.get(file_path)
  end

  def stage
    write
    Git::Run.run :add, '-f', file_path
  end

  def staged?
    Git::Status.get(file_path).staged?
  end

  def commit(author_name)
    Git.commit.apply author_name
  end

  def commited?
    commited_files = Git.commit.files_in_commit(Git.commit.newest)
    commited_files.include?(file_path)
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
require 'git/commit'
require 'git/status'
require 'git/test'
