require 'spec_helper'

describe Assetable::Finders, fs: true do
  Html = Class.new(Assetable::Base){ asset_type :html }

  context '.find' do

    it 'accepts file names with extension' do
      page = Html.new
      page.name = 'test'
      page.content = '<h1>Wow</h1>'
      page.committer = 'alan'
      page.write

      found_page = Html.find('test')
      found_page.should_not be_nil
      found_page.read.should == '<h1>Wow</h1>'
    end

  end

  context '.all' do
    it 'returns array of object of same type the class that called it' do
      page = Html.new
      page.name = 'test'
      page.content = '<h1>Wow</h1>'
      page.committer = 'alan'
      page.write

      pages = Html.all
      pages.should be_a(Array)
      pages.first.should be_a(Html)
      found_page = pages.first
      found_page.read.should == '<h1>Wow</h1>'
    end
  end

end
