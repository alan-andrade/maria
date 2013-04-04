require 'spec_helper'

describe FileControl do
  after(:each){ FileControl.reset }

  describe 'Configuration' do

    it 'throws when a root hasnt been set' do
      expect{
        Struct.new(:attr_we_dont_care) { include FileControl }
      }.to raise_error FileControl::ConfigurationError
    end

    it 'throws when parent doesnt respond to necesary attributes' do
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

    it 'throws when the root provided is nonsense' do
      expect{
        FileControl.root_path = 'xyz/nonsese'
      }.to raise_error FileControl::ConfigurationError
    end

  end

  describe 'Disk Writting' do
    let( :test_dir ){ File.join(Maria::Engine.root, 'spec/.tmp') }
    let( :name )    { 'test.txt' }
    let( :content ) { 'content of this test text' }

    before{ FileControl.root_path =  test_dir}
    after{ FileControl.remove_all! }

    it 'writes the object into disk' do
      file_path = File.join(test_dir, 'test.txt')

      page = Struct.new(:name, :content){
        include FileControl
      }.new name, content

      page.should_not be_written_down
      page.write.should be_true
      page.should be_written_down

      page.read.should == content
    end

    it 'returns NIL when reads the file before is written' do
      page = Struct.new(:name, :content){
        include FileControl
      }.new name, content

      page.read.should be_nil # Should we raise insted?
    end

  end
end
