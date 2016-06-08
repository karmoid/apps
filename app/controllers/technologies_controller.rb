class TechnologiesController < ApplicationController
  def show
    @technology = Technology.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @technology }
    end

  end

  def index
    @technologies = Technology.all
  end
end
