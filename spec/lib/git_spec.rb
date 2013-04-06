require 'spec_helper'

describe Git, git: true do
  before{ FileControl.root_path = FileControl::Test.root_path }
  let(:klass) do
    Txt = Class.new do
      attr_accessor :name, :content
      include Git
    end
  end

  its(:current_branch){ should == 'test'}

  context 'with an object ready' do
    let( :object ){
      c = klass.new
      c.name = 'thing.html'
      c.content = '<p> are you kidding me? </p>'
      c
    }

    it 'should stage a change' do
      object.stage.should be_true
    end

  end
end
