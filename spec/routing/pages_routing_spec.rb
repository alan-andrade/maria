require 'spec_helper'

describe 'Pages routing' do

  it 'requires a brand and/or the name of the page' do
    expect( get: '/pages' ).not_to be_routable
    expect( get: '/pages/jamba' ).to be_routable
    expect( get: '/pages/jamba/prices' ).to be_routable
  end

end
