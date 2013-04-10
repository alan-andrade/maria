module FileControl::Test
  extend self

  def setup
    RSpec.configure do |c|
      # giak, this repetition of code makes me sick!
      c.before(:each){
        if example.example_group.metadata[:git] or
           example.example_group.metadata[:fc]
           FileControl::Test.setup_dirs
           FileControl.root_path = FileControl::Test.root_path
        end
      }
      c.after(:each){
        if example.example_group.metadata[:git] or
           example.example_group.metadata[:fc]
           FileControl::Test.clean!
        end
      }
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
