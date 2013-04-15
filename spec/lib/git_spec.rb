require 'spec_helper'

describe Git, git: true do

  context 'Branch traversing' do
    it 'should return the current branch' do
      Git::Branch.current.should == Git::Branch.current
      Git::Branch.current.should == 'test'
    end

    it 'should switch branches' do
      Git::Branch.force_switch_to 'deleteme'
      Git::Branch.current.should_not == 'test'
      Git::Branch.current.should == 'deleteme'
      Git::Branch.switch_to 'test'
      Git::Branch.delete 'deleteme'
    end
  end

end
