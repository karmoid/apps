class MaintenersController < ApplicationController
  def show
    @maintener = Maintener.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @maintener }
    end

  end

  def index
    @mainteners = Maintener.all
  end
end
