require 'spec_helper'

describe Maria::PagesController do

  it 'should render a form' do
    get :new
    response.should render_template 'maria/pages/new'
  end

  it 'should render new there where errors with the form' do
    post :create
    response.should render_template 'maria/pages/new'
  end

  it 'should redirect to index when has all attributes' do
    post :create, page: { name: 'cool beans',
                          content: 'meh.',
                          committer: 'name' }
    response.should redirect_to pages_path
  end

end
