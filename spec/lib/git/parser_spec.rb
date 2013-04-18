require 'spec_helper'

describe Git::Parser do

  context 'Status Parsing' do
    context "AD lib/git.rb" do
      subject { Git::Parser.parse(:status, "AD lib/git.rb") }
      it{ should be_kind_of(Git::Status) }
      its(:x){ should == 'A' }
      its(:y){ should == 'D' }
      its(:filename){ should == 'lib/git.rb' }
    end

    context " M lib/git.rb" do
      subject{ Git::Parser.parse(:status, " M lib/git.rb") }
      its(:x){ should == ' ' }
      its(:y){ should == 'M' }
    end

    context "empty string" do
      subject{ Git::Parser.parse(:status, '') }
      its(:x){ should == '' }
      its(:y){ should == '' }
    end

    context "A  lib/git.rb" do
      subject{ Git::Parser.parse(:status, "A  lib/git.rb") }
      its(:x){ should == 'A' }
      its(:y){ should == ' ' }
    end
  end

  context 'Commits Parsing' do
    let(:line){ ["e2dc690 improvements to API design",
                  "06b8345 Fake repo, tests improvements"] }

    subject{ Git::Parser.parse(:commits, line) }

    it{ should be_a(Git::CommitsArray) }
    its(:first){ should be_a Git::Commit }

  end

end

