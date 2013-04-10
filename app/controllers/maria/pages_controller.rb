module Maria
  class PagesController < ApplicationController

    def new
      @page = Page.new
    end

    def create
      @page = Maria::Page.new(params[:page])
      @page.save ?
        redirect_to(action: :index) :
        render(:new)
    end

    def index
      @pages = Page.all
    end

    def show
      @page = Page.find(params[:name])
    end

  end
end
