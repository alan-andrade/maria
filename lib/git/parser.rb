module Git

  module StatusParser
    extend self

    REGEX = /^(?<x>[\w| ]{1})(?<y>[\w| ]{1})\s(?<filename>(.*))/

    def parse(line)
      if line.match(REGEX){|match| return Status.new  match[:x],
                                                      match[:y],
                                                      match[:filename]
                          }
      else
        Status.new '', '', ''
      end
    end
  end

  module CommitsParser
    extend self
    REGEX = /^(?<sha>[0-9a-f]{7})\s(?<message>.*)/

    def parse(commits)
      commits.map do|l|
        l.match(REGEX){|m| Commit.new m[:sha], m[:message] }
      end
    end
  end


  module Parser
    extend self

    def parse(type, line)
      parser = "Git::" + type.to_s.capitalize + "Parser"
      parser.constantize.parse(line)
    end

  end

end
