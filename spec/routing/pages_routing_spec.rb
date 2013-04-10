require 'spec_helper'

describe 'Pages routing' do

  it 'responds to all CRUD routes' do
    expect( get: 'pages/new' ).to be_routable
    expect( get: 'pages/1' ).to be_routable
    expect( delete: 'pages/1' ).to be_routable
    expect( put: 'pages/1' ).to be_routable
  end

end
