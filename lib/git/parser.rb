module Git
  # Parser
  #
  # Is just an interface that knows which parser to use. The way we parse a
  # commit and a status is a bit different so we splitted them into separate
  # modules.
  #
  # Git::Parser.parse(:status, 'status line or array and stuff')
  # #=> StatusObject
  module Parser
    extend self

    def parse(type, line)
      parser = "Git::" + type.to_s.capitalize + "Parser"
      parser.constantize.parse(line)
    end
  end


  # Status Parser
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

  # CommitsParser
  module CommitsParser
    extend self
    REGEX = /^(?<sha>[0-9a-f]{7})\s(?<message>.*)/

    def parse(commits)
      commits.map! do |l|
        l.match(REGEX){|m| Commit.new m[:sha], m[:message] }
      end
      CommitsArray.new(commits)
    end
  end
end
