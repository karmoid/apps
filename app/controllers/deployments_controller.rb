class DeploymentsController < ApplicationController
  def show
    @deployment = Deployment.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deployment }
    end

  end

  def index
    @deployments = Deployment.all
  end
end
