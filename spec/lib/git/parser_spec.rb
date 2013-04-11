require 'spec_helper'

describe Git::Parser do

  it 'should parse a status line' do

    line = "AD lib/git.rb"
    parsed = Git::Parser.new(line).parse
    parsed.should be_kind_of(Git::ParsedStatus)

    parsed.x.should == 'A'
    parsed.y.should == 'D'
    parsed.filename.should == 'lib/git.rb'

    line = " M lib/git.rb"
    parsed = Git::Parser.new(line).parse
    parsed.x.should == ' '
    parsed.y.should == 'M'

    line = '' # when no file
    parsed = Git::Parser.new(line).parse
    parsed.x.should == ''
    parsed.y.should == ''

    line = "A  lib/git.rb"
    parsed = Git::Parser.new(line).parse
    parsed.x.should == 'A'
    parsed.y.should == ' '
  end

end

