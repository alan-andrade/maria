module FileControl::Test
  extend self

  def setup
    Dir.mkdir(root_path) unless Dir.exists?(root_path)

    RSpec.configure do |c|
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
    `rm -rf #{root_path}/*` # Kill'em all.
  end

end

module FileControl::TestHelpers
  TestFile = Struct.new(:name,:content) do
    include FileControl
  end

  def file_mock
    TestFile.new('test_dummy', 'I love dummy files :)')
  end

end
