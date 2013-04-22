require 'spec_helper'

describe Assetable, fc: true, git: true do

  UnstableAsset  = Class.new(Assetable::Base)
  StableAsset    = Class.new(Assetable::Base){ asset_type :dummy }

  it 'needs an asset type to create an instance' do
    expect{ UnstableAsset.new }.to raise_error
     UnstableAsset.asset_type :dummy
    expect{ UnstableAsset.new }.not_to raise_error
  end

  context 'with a well configured class' do
    subject{ StableAsset.new }
    its(:max_size){ should == 5 }
    its(:asset_type){ should == :dummy }
    its(:extension){ should == 'dummyext' }
  end

  context 'validations' do
    it 'should have name and content' do
      asset = StableAsset.new
      asset.should_not be_valid
      asset.errors.should_not be_empty
    end

    it 'wont let use names with weird characters' do
      asset = StableAsset.new
      asset.content = '.'
      asset.committer = 'me'
      asset.basename = 'spaces not good'
      asset.should_not be_valid
    end

    it 'should validate that content is not huge' do
      asset = StableAsset.new(content: 'this is more than dummy can support')
      asset.should_not be_valid
      asset.errors.full_messages.to_sentence.should match /Content is too big/
    end
  end

  context 'how files should look like' do
    it 'should have the correct extension' do
      asset = StableAsset.new(content: 'meh', basename: 'woot')
      asset.write
      path = asset.file_path
      File.extname(path).should == '.dummyext'
    end
  end

  context 'Asset persistence' do
    it 'should push to repo when saved' do
      asset = StableAsset.new(content: 'meh', basename: 'cool_name', committer: 'me')
      asset.save
      asset.should be_pushed
    end
  end

end
