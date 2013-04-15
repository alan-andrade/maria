require 'spec_helper'

describe Git, git: true do

  let(:file){ file_mock }

  before { file.class.class_eval{ include Git } }

  it '.status should return a Git::Status object' do
    file.status.should be_kind_of(Git::Status)
    file.status.should_not be_in_wt
    file.status.should_not be_in_index

    file.write
    file.status.should_not be_in_wt # not tracked yet
    file.status.should_not be_in_index

    file.stage
    file.status.should be_in_wt # now we're tracking it
    file.status.should be_in_index
  end
end
