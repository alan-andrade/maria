require 'spec_helper'

describe Maria::Page do

  describe '#new' do
    it { should respond_to(:body) }
    it { should respond_to(:name) }
  end

  describe '#save' do
    let( :page ){ Maria::Page.new body: '%h1 title',
                                  name: 'index' }

    it 'should write the file' do
      page.save
      page.should be_persisted
    end

  end

  # Github persisted model:
  #
  # New     : File.write ''
  # Create  : git add _filename_; git commit -m 'Commiter name'; git push;
  # Edit    : File.read '';
  # Update  : File.write ''; git add _filename_; git commit -m '', git push;
  # Destroy : File.delete ''; git rm _filename_; git commit -m ''; git push;

end
