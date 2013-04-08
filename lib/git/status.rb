module Git

  module Status
    extend self

    def get(file_path)
      Git::StatusLine.new(file_status file_path)
    end

    def file_status(file_path)
      File.exists?(file_path) ?
        Git::Run.exec(:status, '--porcelain', file_path).split(/\n/).first :
        nil
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
