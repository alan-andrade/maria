require 'spec_helper'

describe Git::Commit, git: true do

  before do
    #fake_commits
    Git::Run.stub(log: ["e2dc690 improvements to API design"])
    #fake_files_in_commits
    Git::Run.stub("diff_tree" => ['test', 'dummy.txt'])
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

  end

end
