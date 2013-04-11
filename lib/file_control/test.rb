module FileControl::Test
  extend self

  def setup
    RSpec.configure do |c|
      c.before(:each){
         FileControl::Test.setup_dirs
         FileControl.root_path = FileControl::Test.root_path
      }
      c.after(:each){ FileControl::Test.clean!  }
    end # /rspec
  end

  def root_path
    File.join(Maria::Engine.root, 'spec/.tmp')
  end

  def clean!
    `rm -rf #{root_path}` # Kill'em all.
  end

  def setup_dirs
    Dir.mkdir(root_path) unless Dir.exists?(root_path)
  end

end

module FileControl::TestHelpers
  TestFile = Struct.new(:name, :content) do
    include FileControl
  end

  def file_mock
    TestFile.new('test_dummy', 'I love dummy files :)')
  end
end
