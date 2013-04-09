require 'active_support/core_ext/string/inflections'

# Git module
#
# When included, you could persist(commit) any instance as long as it
# reponds to
#
#   # file_path
#   # name
#   # content
#
# Normally you will include FileControl along with Git so that everything
# runs smoothly.
#
# Do it as follows:
#
#
# class Album
#   attr_accessor :name, :content
#
#   include FileControl
#   include Git
# end
#
# album = Album.new
# album.name 'In Rainbows'
# album.content 'Pure awesome music'
#
# Git functionallity
#
# album.stage
# album.stage? #=> true
# album.commit('Thom Yorke')
# album.commited? #=> true
#
# Library still with a lot work to do. Don't expect more than this.
module Git

  # status
  #
  # Returns the status object for the file
  def status
    Git::Status.get(file_path)
  end

  # stage
  #
  # Will stage or add the file to index.
  def stage
    write
    Git::Run.run :add, '-f', file_path
  end

  # staged?
  #
  # Seeks under file status and verify is staged using the git
  # index and working tree notation.
  def staged?
    Git::Status.get(file_path).staged?
  end

  # commit
  #
  # 'Persist' or commit the file.
  def commit(author_name)
    Git.commit.apply author_name
  end

  # commited?
  #
  # Using the last commit, checks if it was touched or not.
  #
  # Bit complicated logic to determined if a file is committed or not.
  #
  # If the file is found in the last commit, we still need to check that
  # hasn't been updated.
  #
  # I'm sure there's a better way to get this.
  def committed?
    committed_files = Git.commit.files_in_commit(Git.commit.newest)
    found = committed_files.include?(file_path)

    status.new_file? ?
      found :
      found and !status.updated?
  end

  #
  # Will redirect every call to submodules if any.
  #
  # Git.commit.list => Calls Git::Commit.list
  # Git.status.staged? => Calls Git::Status.staged?
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
