require 'spec_helper'

describe Maria::PagesController do

  it 'defaults name to index' do
    get :show, brand: 'jamba'
    response.should render_template 'pages/jamba/index'
  end

  it 'renders the page passed as name' do
    get :show, brand: 'jamba', name: 'learn_more'
    response.should render_template 'pages/jamba/learn_more'
  end

end
