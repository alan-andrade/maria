module Git
  module Commits
    extend self

    def last
      list.first
    end

    def list(n=10)
      Git::Parser.parse(:commits, Git::Run.log(n))
    end

  end
end
