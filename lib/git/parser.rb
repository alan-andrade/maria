module Git

  class ParsedStatus
    attr_reader :x, :y, :filename

    def initialize(match_data)
      if match_data.nil?
        @x , @y, @filename = '', '', ''
      else
        letters = match_data[:status].split(//) # separate each letter
        @x, @y = letters.first, letters.last
        @filename = match_data[:filename]
      end
    end
  end

  class Parser
    STATUS_EXP = /^(?<status>[\w| ]{2})\s(?<filename>.*)/

    def initialize(status_line)
      @status_line = status_line
    end

    def parse
      ParsedStatus.new(@status_line.match(STATUS_EXP))
    end

  end

end
