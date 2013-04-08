require 'active_support/core_ext/string/inflections'

module Git

  def stage
    write
    Git::Run.run :add, '-f', file_path
  end

  def status
    Git::Status.get(file_path)
  end

  def commit(author_name)
    throw ArgumentError, 'Please provide an author name to proceed' if author_name.nil?
    Git::Run.run :commit, "-m '#{author_name}'"
  end

  def commited?
    last_commit = Git::Run.exec :log, '-1', '--oneline'
    last_commit_sha = last_commit.match(/(^\w{7})(.*)/)[1]
    files = Git::Run.exec 'diff-tree', '--no-commit-id --name-only -r', last_commit_sha
    pathnames = files.split(/\n/).map{|git| File.expand_path git }
    pathnames.include?(file_path)
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
