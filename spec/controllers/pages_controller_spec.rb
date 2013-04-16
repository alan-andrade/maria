require 'spec_helper'

describe Maria::PagesController, git: true do

  it 'should render a form' do
    get :new
    response.should render_template 'maria/pages/new'
  end

  it 'should render new there where errors with the form' do
    post :create
    response.should render_template 'maria/pages/new'
  end

  it 'should redirect to index when has all attributes' do
    post :create, page: { name: 'jamba_beans',
                          content: 'meh.',
                          committer: 'name' }
    response.should redirect_to pages_path
  end

  it 'should render a form when editing' do
    Maria::Page.stub find: Maria::Page.new(name: 'test', content: 'html stuff')
    get :edit, id: 'test'
    response.should render_template 'maria/pages/edit'
  end

  it 'should update the page' do
    page = Maria::Page.new(name: 'test', content: 'foo')
    page.save
    Maria::Page.stub find: page

    put :update, id: 'test', page: { content:'bar',
                                     committer: 'tester' }
    response.should redirect_to page_path(page)
  end

end
