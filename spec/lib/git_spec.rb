require 'spec_helper'

describe Git, git: true do
  before{ FileControl.root_path = FileControl::Test.root_path }

  context 'Branch traversing' do
    it 'should return the current branch' do
      Git.branch.current.should == Git::Branch.current
      Git.branch.current.should == 'test'
    end

    it 'should switch branches' do
      Git.branch.force_switch_to 'deleteme'
      Git.branch.current.should_not == 'test'
      Git.branch.current.should == 'deleteme'
      Git.branch.switch_to 'test'
      Git.branch.delete 'deleteme'
    end
  end

  context 'Committing and Staging files' do
    let(:file){ file_mock }

    before{ file.class.class_eval{ include Git } }

    it 'should stage (add) the file to the index' do
      file.should_not be_written
      file.status.should_not be_staged
      file.stage
      file.should be_written
      file.status.should be_staged
    end

    it 'should commit the file' do
      file.stage
      file.commit('name of comitter')
      file.status.should be_commited
    end

  end

end
