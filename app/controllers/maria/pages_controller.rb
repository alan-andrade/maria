module Maria
  class PagesController < ApplicationController

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(params[:page])
      @page.save ?
        redirect_to(pages_path) :
        render(:new)
    end

    def index
      @pages = Page.all
    end

    def show
      @page = Page.find(params[:id])
    end

    def edit
      @page = Page.find(params[:id])
    end

    def update
      @page = Page.find(params[:id])
      if @page.update_attributes(params[:page])
        redirect_to page_path(@page)
      else
        render(:edit)
      end
    end

  end
end
