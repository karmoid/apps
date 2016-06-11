class DeploymentsController < ApplicationController
  def show
    @deployment = Deployment.find(params[:id])
    @hosts = Host.joins([:deployment, techno_instances: {realisations: [:lifecycle]}]).where(deployments: {id: @deployment.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deployment }
    end

  end

  def index
    @deployments = Deployment.all
  end
end
