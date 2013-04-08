require 'spec_helper'

describe Git, git: true do

  let(:file){ file_mock }

  context 'With a staged filed' do

    before {
      FileControl.root_path = FileControl::Test.root_path
      Git::Status.stub file_status: "AD spec/.tmp/filecontrol::testhelpers::testfile/test_dummy\n"
      file.class.class_eval{ include Git }
    }

    it 'should say is staged and deleted from working tree' do
      # => AD means is added, but deleted in the working tree.
      file.stage
      file.status.should be_staged
    end

  end

end
