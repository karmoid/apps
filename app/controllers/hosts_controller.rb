class HostsController < ApplicationController
  def show
    @host = Host.find(params[:id])

    @techno_instances = @host.techno_instances
    @deployment = @host.deployment
    @technologies = @host.technologies
    @applications = Application.joins(app_modules: {realisations: :techno_instances}).where(techno_instances: {host_id: @host.id}).distinct
    @app_modules = AppModule.joins(realisations: :techno_instances).where(techno_instances: {host_id: @host.id}).distinct
    @realisations = Realisation.joins(:techno_instances).where(techno_instances: {host_id: @host.id}).distinct

    @lifecycles = Lifecycle.joins(realisations: :techno_instances).where(techno_instances: {host_id: @host.id}).distinct
    @contracts = @host.contracts

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @host }
    end

  end

  def index
    @hosts = Host.all
  end
end
