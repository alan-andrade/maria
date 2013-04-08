module Git

  class Commit
    attr_reader :sha, :filename

    def initialize(attributes={})
      @sha = attributes.fetch(:sha)
      @filename = attributes.fetch(:filename)
    end

    def self.apply(author_name)
      throw ArgumentError, 'Please provide an author name to proceed' if author_name.nil?
      Git::Run.run :commit, "-m '#{author_name}'"
    end

    def self.list(n=1)
      CommitParser.parse(Git::Run.exec(:log, "-#{n}", '--oneline'))
    end

    def self.files_in_commit(commit, complete_path=true)
      raw_files = Git::Run.exec('diff-tree', '--no-commit-id --name-only -r', commit.sha)
      files = raw_files.split
      files.map!{|f| File.expand_path f } if complete_path
      files
    end

    def self.newest
      list.first
    end

  end #/commit

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
