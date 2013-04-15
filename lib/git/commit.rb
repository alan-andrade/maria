module Git

  class Commit
    attr_reader :sha, :filename

    def initialize(sha, message)
      @sha = sha
      @message = message
    end

    def files
      Git::Run.diff_tree(self.sha).map{|f| File.expand_path f }
    end

    # Apply a commit to the working directory.
    #
    # It requires the name of the committer.
    def self.apply(author_name)
      author_name = author_name || committer
      throw ArgumentError, 'Please provide an author name to proceed' if author_name.nil?
      Git::Run.run :commit, "-m '#{author_name}'"
    end

  end #/commit
end #/ git
