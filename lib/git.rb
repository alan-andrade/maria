require 'active_support/core_ext/module'
# Git module
#
# When included, you an persist(commit) any instance as long as it
# reponds to
#
#   # file_path
#   # name
#   # content
#
# Normally you will include FileControl along with Git so that everything
# runs 'smoothly'.
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
#
# It's important to know that when we commit, we need to pass the commit message.
# You can also set the attribute committer in the asset and
# commit will automatically detect it.
module Git

  # Attributes accessor for configuration tasks.
  #
  # remote: remote end point. This could be the fake one under spec/repo.
  # remote_url: remote end point url.
  # root: Root folder which git will use to expand files urls.
  mattr_accessor :remote, :remote_url, :root

  # status
  #
  # This is a wrapper of a git status call with the file as the parameter.
  # The status object can tell you if the file is committed or staged.
  #
  # Short functionality in the status implementation right now.
  def status
    Git::Status.get(self.file_path)
  end

  # stage
  #
  # Will write the file and then stage it or move it to the 'index'.
  # All weird git terms...
  def stage
    write
    Git::Run.run :add, '-f', file_path
  end

  # staged?
  #
  # Are we tracking the file in the index?
  def staged?
    Git::Status.get(file_path).in_index?
  end

  # Commit
  #
  # Apply a commit with the file changes.
  def commit(author_name=nil)
    Git::Commit.apply(author_name || committer)
  end

  # committed?
  #
  # Determines if the file was committed before. To do this, we take
  # the last commit files and verify if the file name is in the list.
  # A bit weak, but enough for now.
  def committed?
    return false if status.in_wt? or status.in_index?
    files = Git::Commits.last.files
    files.include?(file_path)
  end

  # push
  #
  # Push the branch commits to a remote repository.
  #
  # We use Git configuration variables here to separate environments behaviour.
  def push
    return false unless committed?
    Git::Run.push(Git.remote)
  end

  # pushed?
  #
  # Is the file really in the remote repo?
  #
  # The way we check this is similar to committed? We do a diff_tree but
  # with the remote branch as target.
  def pushed?
    Git::Run.diff_tree(Git.remote_url).
      map{|f| File.expand_path f }.include? file_path
  end
end

%w(run branch commit commits parser repo status).each do |f|
  require 'git/' + f + '.rb'
end
