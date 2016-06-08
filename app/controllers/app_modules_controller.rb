class AppModulesController < ApplicationController
  def show
    @app_module = AppModule.find(params[:id])

    @application = @app_module.application
    @maintener = @application.maintener
    @mainteners = @maintener.people unless @maintener.nil?

    @people = @app_module.people.distinct

    @hosts = Host.joins(techno_instances: {realisations: [:app_modules, :lifecycle]}).where(app_modules: {id: @app_module.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct
    @hostscount = @hosts.distinct.count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app_module }
    end

  end

  def index
    @app_modules = AppModule.all
  end
end
