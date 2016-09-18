class HostsController < ApplicationController
  def show
    @host = Host.find(params[:id])
    @host_model = @host.host_model
    @clones = @host.clones

    @deployment = @host.deployment
    @discovery_attributes = @host.discovery_attributes.order("discovery_id, attribute_type_id, discovery_attributes.id")

    @techno_instances = ApplicationHelper::concatener_dataset(@host.techno_instances, @host_model.nil? ? nil : @host_model.techno_instances)
    @technologies = ApplicationHelper::concatener_dataset(@host.technologies, @host_model.nil? ? nil : @host_model.technologies)
    @documents = ApplicationHelper::concatener_dataset(@host.documents, @host_model.nil? ? nil : @host_model.documents)
    @contracts = ApplicationHelper::concatener_dataset(@host.contracts, @host_model.nil? ? nil : @host_model.contracts)

    @applications = Application.joins(app_modules: {realisations: :techno_instances}).where("techno_instances.host_id in (:host_id,:host_model_id)", {host_id: @host.id, host_model_id: @host.host_model_id}).distinct
    @app_modules = AppModule.joins(realisations: :techno_instances).where("techno_instances.host_id in (:host_id,:host_model_id)", {host_id: @host.id, host_model_id: @host.host_model_id}).distinct
    @realisations = Realisation.joins(:techno_instances).where("techno_instances.host_id in (:host_id,:host_model_id)", {host_id: @host.id, host_model_id: @host.host_model_id}).distinct

    @lifecycles = Lifecycle.joins(realisations: :techno_instances).where("techno_instances.host_id in (:host_id,:host_model_id)", {host_id: @host.id, host_model_id: @host.host_model_id}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @host }
    end

  end

  def index
    @hosts = Host.all
  end
end
