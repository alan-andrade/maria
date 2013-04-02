module Maria
  class PagesController < ApplicationController

    def show
      render "pages/#{brand}/#{name}"
    end

    private

    def brand
      params[:brand]
    end

    def name
      params[:name] or 'index'
    end

  end
end
