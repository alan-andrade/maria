module Git

  # Git Status module
  #
  # Tool to determine the current status of a file.
  #
  # Right now is super basic.
  module Status
    extend self

    # get
    #
    # Will return the StatusLine of the file_path
    def get(file_path)
      Git::StatusLine.new file_status(file_path)
    end

    # file_status
    #
    # returns the raw status of file_path
    def file_status(file_path)
      File.exists?(file_path) ?
        Git::Run.exec(:status, '--porcelain', file_path).split(/\n/).first :
        nil
    end

  end #/Status

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
      @x == "A"
    end

  end # /statusline

  # EmptyStatusLine
  #
  # Used when we query the status of a file that doesn't exists :(
  class EmptyStatusLine
    def initialize; self; end
    def staged?; false; end
  end

end
