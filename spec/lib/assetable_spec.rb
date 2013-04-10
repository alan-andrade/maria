require 'spec_helper'
require 'assetable/dummy'

describe Assetable, fc: true do

  Unstable  = Class.new(Assetable::Base)
  Stable    = Class.new(Assetable::Base){ asset_type :dummy }

  it 'needs an asset type to create an instance' do
    expect{ Unstable.new }.to raise_error
     Unstable.asset_type :dummy
    expect{ Unstable.new }.not_to raise_error
  end

  context 'with a well configured class' do
    subject{ Stable.new }
    its(:max_size){ should == 5 }
    its(:asset_type){ should == :dummy }
    its(:extension){ should == 'dummyext' }
  end

  context 'validations' do
    it 'should have name and content' do
      asset = Stable.new
      asset.should_not be_valid
      asset.errors.should_not be_empty
    end

    it 'should validate that content is not huge' do
      asset = Stable.new(content: 'this is more than dummy can support')
      asset.should_not be_valid
      asset.errors.full_messages.to_sentence.should match /Content is too big/
    end
  end

  context 'how files should look like' do
    it 'should have the correct extension' do
      asset = Stable.new(content: 'meh', name: 'woot')
      asset.write
      path = asset.file_path
      File.extname(path).should == '.dummyext'
    end
  end

end
