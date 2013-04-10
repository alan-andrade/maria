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

  it 'should redirect to index when is cool' do
    post :create, name: 'cool', content: 'meh.', committer: 'name'
    response.should redirect_to :index
  end

end
