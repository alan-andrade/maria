module Git
  class Commit
    # Commit
    #
    # Represents a commit and has two attributes.
    #
    # sha and message
    attr_reader :sha, :message

    def initialize(sha, message)
      @sha = sha
      @message = message
    end

    # files
    #
    # You can have an array of files that were touched on the commit.
    def files
      files = Git::Run.diff_tree(self.sha)
      files.map{|f| File.expand_path f, Git.root }
    end

    # Apply a commit to the working directory.
    #
    # It requires the name of the committer.
    def self.apply(author_name)
      throw ArgumentError, 'Please provide an author name to proceed' if author_name.nil?
      Git::Run.commit "-m '#{author_name}'"
    end
  end #/commit
end #/ git
