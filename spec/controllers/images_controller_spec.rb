require 'spec_helper'

module Maria
  describe ImagesController, git: true do

    let(:file){ Rack::Test::UploadedFile.new(File.expand_path('../../fixtures/test.png',__FILE__), 'image/png') }

    it 'should upload a file' do
      expect{
        post :create, image: { file: file, basename: 'test', committer: 'tester' }
      }.to change{Image.count}.by(1)
      response.should redirect_to image_path(id: 'test')
    end

  end
end
