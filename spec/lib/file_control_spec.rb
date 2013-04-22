require 'spec_helper'

describe FileControl, fc: true do
  after(:each){ FileControl.reset }

  describe 'Configuration' do

    it 'throws when class doesnt respond to :name and :content' do
      FileControl.root_path = '.'
      expect{
        Struct.new(:name) { include FileControl }
      }.to raise_error FileControl::RequiredAttributes

      expect{
        Struct.new(:content) { include FileControl }
      }.to raise_error FileControl::RequiredAttributes

      expect{
        Struct.new(:name, :content) { include FileControl }
      }.not_to raise_error FileControl::RequiredAttributes
    end

    it 'throws when the root_path provided doesnt exist' do
      expect{
        FileControl.root_path = 'xyz/nonsese'
      }.to raise_error FileControl::ConfigurationError
    end

  end

  describe 'Nice attributes' do
    class TestableAsset
      attr_accessor :name, :content
      include FileControl
    end

    it 'has understandable attributes' do
      file = TestableAsset.new
      file.name = 'test.txt'
      file.content = 'I just came here to test stuff.'

      file.basename.should == 'test'
      file.extension.should == 'txt'
      file.filename.should == 'test.txt'
    end

  end

  describe 'Disk Writting' do
    let( :test_dir ){ FileControl::Test.root_path }
    let( :name )    { 'test.txt' }
    let( :content ) { 'content of this test text' }

    before{ FileControl.root_path =  test_dir}

    it 'writes the instance to disk taking the class name as dir' do
      file_path = File.join(test_dir, 'test.txt')

      Maria::TestPage = Class.new do
        attr_accessor :name, :content
        include FileControl
      end

      page = Maria::TestPage.new
      page.name = name
      page.content = content

      page.should_not be_written
      page.write.should be_true
      page.should be_written

      page.read.should == content
      # It demodulizes the file_path where its saved
      page.file_path.should_not match(/::/)
    end

    it 'returns nil when reads before writting' do
      page = Struct.new(:name, :content){
        include FileControl
      }.new name, content

      page.read.should be_nil # Should we raise insted?
    end
  end

end
