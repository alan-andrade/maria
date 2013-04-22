module Maria
  class ImagesController < ApplicationController

    def new
      @image = Image.new
    end

    def create
      @image = Image.new(params[:image])
      if @image.valid?
        @image.save
        redirect_to image_path(@image)
      else
        render :new
      end
    end

    def show
      @image = Image.find(params[:id])
    end

  end
end
