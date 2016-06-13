class TechnoInstancesController < ApplicationController
  def show
    @techno_instance = TechnoInstance.find(params[:id])
    @host = @techno_instance.host
    @technology = @techno_instance.technology
    @documents = @techno_instance.documents
    @app_modules = @techno_instance.app_modules
    @applications = @techno_instance.applications

    @realisations = @techno_instance.realisations.group(:lifecycle).count
    @hosts = Host.joins([techno_instances: {realisations: [:lifecycle]}]).where(techno_instances: {id: @techno_instance.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @techno_instance }
    end

  end

  def index
    @techno_instances = TechnoInstance.all
  end
end
