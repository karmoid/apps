class RealisationsController < ApplicationController
  def show
    @realisation = Realisation.find(params[:id])
    @lifecycle = @realisation.lifecycle
    @technologies = @realisation.techno_instances.group(:technology).count
    @app_modules = @realisation.app_modules
    @applications = Application.joins(app_modules: :realisations).where(realisations: {id: @realisation.id}).distinct

    @hosts = Host.joins([techno_instances: {realisations: [:lifecycle]}]).where(realisations: {id: @realisation.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @realisation }
    end

  end

  def index
    @realisations = Realisation.all
  end
end
