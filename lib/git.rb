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
end

require File.dirname(__FILE__) + '/git/run.rb'
Dir[File.dirname(__FILE__) + '/git/*.rb'].each{|f| require f }
