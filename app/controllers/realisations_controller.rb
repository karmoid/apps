class RealisationsController < ApplicationController
  def show
    @realisation = Realisation.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @realisation }
    end

  end

  def index
    @realisations = Realisation.all
  end
end
