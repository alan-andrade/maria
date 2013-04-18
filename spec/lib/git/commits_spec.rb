require 'spec_helper'

describe Git::Commits do

  context 'with 1 commit' do
    before{ Git::Run.stub(log: ["e2dc690 improvements to API design"]) }

    subject{ Git::Commits.list }
    its(:size){ should == 1 }
    its(:last){ be_kind_of(Git::Commit) }

    it{ should be_kind_of(Git::CommitsArray) }
  end

  context 'with 2 or more commits' do
    before{ Git::Run.stub(log: ["e2dc690 improvements to API design",
                                "06b8345 Fake repo, tests improvements"]) }

    subject{ Git::Commits.list }

    it{ should be_kind_of(Git::CommitsArray) }
    its(:size){ should == 2 }
    its(:last){ be_kind_of(Git::Commit) }
  end

end
