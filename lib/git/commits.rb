module Git
  module Commits
    extend self
    # Commits
    #
    # Module to work with commits lists and easily pick any of those.
    #
    # Git::Commits.list
    # # => [Commit1, Commit2]
    #
    # Git::Commits.last
    #
    # #=> MostRecentCommit
    #
    # And from there, you could query for the files of that commit.

    def last
      list.first
    end

    def list(n=10)
      Git::Parser.parse(:commits, Git::Run.log(n))
    end

  end
end
