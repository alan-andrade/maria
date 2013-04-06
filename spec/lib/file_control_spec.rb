require 'spec_helper'

describe FileControl do
  after(:each){ FileControl.reset }

  describe 'Configuration' do

    it 'throws when root_path is not set' do
      expect{
        Struct.new(:attr_we_dont_care) { include FileControl }
      }.to raise_error FileControl::ConfigurationError
    end

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

  describe 'Disk Writting' do
    let( :test_dir ){ FileControl::Test.root_path }
    let( :name )    { 'test.txt' }
    let( :content ) { 'content of this test text' }

    before{ FileControl.root_path =  test_dir}
    after{ FileControl.remove_all! }

    it 'writes the instance to disk taking the class name as dir' do
      file_path = File.join(test_dir, 'test.txt')

      Page = Class.new do
        attr_accessor :name, :content
        include FileControl
      end

      page = Page.new
      page.name = name
      page.content = content

      page.should_not be_written
      page.write.should be_true
      page.should be_written

      page.read.should == content
    end

    it 'returns nil when reads before writting' do
      page = Struct.new(:name, :content){
        include FileControl
      }.new name, content

      page.read.should be_nil # Should we raise insted?
    end
  end

end
