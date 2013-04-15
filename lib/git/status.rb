module Git

  # Git Status module
  #
  # Tool to determine the current status of a file.
  #
  # Right now is super basic.
  class Status
    attr_reader :x, :y, :filename

    def initialize(x, y, filename)
      #@status = Git::Parser.new(Git::Status.run(file_path)).parse
      @x = x
      @y = y
      @filename = filename
    end

    def in_wt?
      !!@y.match(/[ MD]/)
    end

    def in_index?
      !!@x.match(/[ MARC]/)
    end

    def self.get(file_path)
      Git::StatusParser.parse( Git::Run.status(file_path) )
    end

  end #/Status
end
