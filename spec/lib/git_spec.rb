require 'spec_helper'

describe Git, git: true do
  before{ FileControl.root_path = FileControl::Test.root_path }
  let(:klass) do
    Class.new do
      attr_accessor :name, :content
      include Git
    end
  end

  its(:current_branch){ should == 'test'}

  it 'should commit a change' do
    thing = klass.new
    thing.name = 'thing.html'
    thing.content = '<p> are you kidding me? </p>'
    thing.commit
  end

end
