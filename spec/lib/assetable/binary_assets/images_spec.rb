require 'spec_helper'

describe Assetable, git: true do

  let(:tempImage){ File.open(File.expand_path '../../../../support/test.png', __FILE__) }

  Png = Class.new(Assetable::Base){ asset_type :dummy_binary }

  it 'saves a binary asset such as an image' do
    png = Png.new
    png.basename = 'pngimage'
    png.content = tempImage.read
    png.committer = 'John tester testing binaries'
    png.save

    png.should be_written
  end

end
