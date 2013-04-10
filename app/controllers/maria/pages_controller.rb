module Maria
  class PagesController < ApplicationController

    def new
      @page = Maria::Page.new
    end

    def create
      @page = Maria::Page.new(params[:page])
      @page.save ?
        redirect_to(:index) :
        render(:new)
    end

    def index
      @pages = Page.all
    end

  end
end
