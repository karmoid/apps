class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @app_modules = @application.app_modules

    @powers = @application.powers.distinct
    @maintener = @application.maintener
    @mainteners = @maintener.people unless @maintener.nil?

    @hosts = Host.joins(techno_instances: {realisations: [:app_modules, :lifecycle]}).where(app_modules: {application_id: @application.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct
    @hostscount = @hosts.distinct.count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @application }
    end

  end

  def index
    @applications = Application.all
  end
end
