require 'active_support/core_ext/module'
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
# album.staged? #=> true
# album.commit('Thom Yorke')
# album.commited? #=> true
#
# Library still with a lot work to do. Don't expect more than this.
module Git
  mattr_accessor :remote, :remote_url

  # status
  #
  # Returns the status object for the file
  def status
    Git::Status.get(self.file_path)
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
    Git::Status.get(file_path).in_index?
  end

  # commit
  #
  # 'Persist' or commit the file.
  def commit(author_name)
    Git::Commit.apply author_name
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
    return false if status.in_wt? or status.in_index?
    files = Git::Commits.last.files
    files.include?(self.file_path)
  end

  def push
    return false unless committed?
    Git::Run.push(Git.remote)
  end

  def pushed?
    Git::Run.diff_tree(Git.remote_url, Git::Commits.last.sha).
      map{|f| File.expand_path f }.include? self.file_path
  end

end

require File.dirname(__FILE__) + '/git/run.rb'
Dir[File.dirname(__FILE__) + '/git/*.rb'].each{|f| require f }
