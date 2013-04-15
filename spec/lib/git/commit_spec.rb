require 'spec_helper'

describe Git::Commit, git: true do

  before do
    #fake_commits
    Git::Run.stub(log: ["e2dc690 improvements to API design"])
    #fake_files_in_commits
    Git::Run.stub("diff_tree" => ['spec/.tmp/testfiles/test_dummy.', 'dummy.txt'])
  end

  it 'contains the files under the commit' do
    Git::Commits.last.files.should be_a(Array)
  end

  it 'can tell if its commited or not' do
    file = file_mock
    file.class.class_eval{ include Git }
    file.should_not be_staged
    file.write
    file.stage
    file.should be_staged
    file.should_not be_committed
    file.commit('andrade')
    file.should be_committed

    file.content = 'Troll content'
    file.write
    file.stage
    file.should_not be_committed
    file.commit('andrade 2')
    file.should be_committed
  end

  it 'should push a commit to remote' do
    file = file_mock
    file.class.class_eval{ include Git }
    file.write
    file.stage
    file.commit('w00t')
    file.push
    file.should be_pushed
  end

end
