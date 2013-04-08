module Git

  module Status
    extend self

    def get(file_path)
      status_result = Git::Run.exec(:status, '--porcelain', file_path)
      status_line = status_result.split(/\n/).first
      Git::StatusLine.new(status_line)
    end

  end #/Status

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

    def staged?
      @x == "A"
    end

  end # /statusline

  class EmptyStatusLine
    def initialize; self; end
    def staged?; false; end
  end

end
