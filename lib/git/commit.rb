module Git

  # Commit class
  #
  # Representation of a commit or a list of commits.
  class Commit
    attr_reader :sha, :filename

    def initialize(attributes={})
      @sha = attributes.fetch(:sha)
      @filename = attributes.fetch(:filename)
    end

    # Apply a commit to the working directory.
    #
    # It requires the name of the committer.
    def self.apply(author_name)
      throw ArgumentError, 'Please provide an author name to proceed' if author_name.nil?
      Git::Run.run :commit, "-m '#{author_name}'"
    end

    # List of Commits
    #
    # Defaulting the oneline format and only the last.
    #
    # The only thing is configurable right now is the amount of commits you
    # want to display. We're using the default.
    def self.list(n=1)
      raw_commits = Git::Run.exec(:log, "-#{n}", '--oneline')
      CommitParser.parse(raw_commits)
    end

    # Nicely formatted array of files absolute paths that where
    # touched in the last commit.
    #
    # Commit should have the sha available for reading.
    # In the future we might want to implemenet more formatters, that's
    # why have the 2 argument. We're not using it right now, just trying
    # to express intent.
    def self.files_in_commit(commit, complete_path=true)
      raw_files = Git::Run.exec('diff-tree', '--no-commit-id --name-only -r', commit.sha)
      files = raw_files.split
      files.map!{|f| File.expand_path f } if complete_path
      files
    end

    # Shorthand for the newest commit.
    def self.newest
      list.first
    end

  end #/commit

  # CommitParser
  #
  # module dedicated only to parse and create new Commit objects from
  # an arrya of commits formatted with the oneline format.
  module CommitParser
    extend self

    FORMATS = {
      oneline: /(^\w{7})(.*)/
    }

    def parse(raw_commits, format=:oneline)
      commits = raw_commits.split
      commits.map! do |commit|
        commit.match(FORMATS[format]){|m|
          Commit.new sha: m[1],
                     filename: m[2] }
      end
    end

  end #/ commit parser

end #/ git
