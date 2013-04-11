module Git

  # Git Status module
  #
  # Tool to determine the current status of a file.
  #
  # Right now is super basic.
  class Status
    attr_reader :status

    def initialize(file_path)
      @status = Git::Parser.new(Git::Status.run(file_path)).parse
    end

    def in_wt?
      !!@status.y.match(/[ MD]/)
    end

    def in_index?
      !!@status.x.match(/[ MARC]/)
    end

    def get(file_path)
      Git::StatusLine.new file_status(file_path)
    end

    def file_status(file_path)
      File.exists?(file_path) ?
        Git::Run.exec(:status, '--porcelain', file_path).split(/\n/).first :
        nil
    end

    def self.run(file_path)
      result = nil
      if File.exists?(file_path)
        result = Git::Run.exec(:status, '--porcelain', file_path)
        result = result.first
      end

      result or ''
    end

  end #/Status


  class StatusParser

    def initialize(file_path)
      @raw_status = Git::Run.exec(:status, '--porcelain', file_path)
      @status_line = @raw_status.split(/\n/).first
    end

    def parse
      @status_line
    end

  end #/Status parser

  # StatusLine class
  #
  # This is confusing right now... I'll try to explain.
  #
  # When we run git status --porcelain,
  # we get a list of files with their status marked with 2 letters, which can
  # be spaces to.
  #
  # Read more in man git-status so that you understand whats going on with
  # the X and Y properties of a status line.
  class StatusLine
    REGEXP = /^([ MARCD])([ MDUA?!]) (.*)/

    def initialize(line)
      return Git::EmptyStatusLine.new if line.nil?
      line.match REGEXP do |m|
        @x = m[1]
        @y = m[2]
        @file = m[3]
      end
    end

    # staged?
    #
    # Determines if the file is added to the INDEX, not the working directory.
    def staged?
      @x == "A" or updated?
      # A means is a new file we just added.
      # M means a file we added before, that has changed
    end

    def updated?
      @x == "M"
    end

    # Means a new file we just staged.
    def new_file?
      @x.nil? and @y.nil?
    end

  end # /statusline

  # EmptyStatusLine
  #
  # Used when we query the status of a file that doesn't exists :(
  class EmptyStatusLine
    def initialize; self; end
    def staged?; false; end
    def new_file?; false; end
    def updated?; false; end
  end

end
