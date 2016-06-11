class TechnologiesController < ApplicationController
  def show
    @technology = Technology.find(params[:id])

    @techno_instances = @technology.techno_instances
    @hosts = Host.joins(techno_instances: :technology).where(technologies: {id: @technology.id}).distinct
    @realisations = Realisation.joins(techno_instances: :technology).where(technologies: {id: @technology.id}).group(:lifecycle).count
    @hosts = Host.joins(techno_instances: [:technology, {realisations: [:lifecycle]}]).where(technologies: {id: @technology.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @technology }
    end

  end

  def index
    @technologies = Technology.all
  end
end
