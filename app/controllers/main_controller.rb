class MainController < ApplicationController

  def index
    @app_modules_c = AppModule.where(AppModule.arel_table[:created_at].gt(Date.today-3)).
                               order(created_at: :desc).limit(5)
    @app_modules_u = AppModule.where(AppModule.arel_table[:updated_at].gt(Date.today-3)).
                               where(AppModule.arel_table[:created_at].lt(Date.today-3)).
                               order(updated_at: :desc).limit(5)
    @applications_c = Application.where(Application.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @applications_u = Application.where(Application.arel_table[:updated_at].gt(Date.today-3)).
                              where(Application.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)
    @technologies_c = Technology.where(Technology.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @technologies_u = Technology.where(Technology.arel_table[:updated_at].gt(Date.today-3)).
                              where(Technology.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)
    @techno_instances_c = TechnoInstance.where(TechnoInstance.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @techno_instances_u = TechnoInstance.where(TechnoInstance.arel_table[:updated_at].gt(Date.today-3)).
                              where(TechnoInstance.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)
    @realisations_c = Realisation.where(Realisation.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @realisations_u = Realisation.where(Realisation.arel_table[:updated_at].gt(Date.today-3)).
                              where(Realisation.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)


    @app_roles_c = AppRole.where(AppRole.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @app_roles_u = AppRole.where(AppRole.arel_table[:updated_at].gt(Date.today-3)).
                              where(AppRole.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)
    @contracts_c = Contract.where(Contract.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @contracts_u = Contract.where(Contract.arel_table[:updated_at].gt(Date.today-3)).
                              where(Contract.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)
    @mainteners_c = Maintener.where(Maintener.arel_table[:created_at].gt(Date.today-3)).
                              order(created_at: :desc).limit(5)
    @mainteners_u = Maintener.where(Maintener.arel_table[:updated_at].gt(Date.today-3)).
                              where(Maintener.arel_table[:created_at].lt(Date.today-3)).
                              order(updated_at: :desc).limit(5)

    @app_roles_count = AppRole.all.count
    @deployments_count = Deployment.all.count
    @entities_count = Entity.all.count
    @hosts_count = Host.all.count
    @lifecycles_count = Lifecycle.all.count
    @mainteners_count = Maintener.all.count
    @people_count = Person.all.count
    @realisations_count = Realisation.all.count
    @techno_instances_count = TechnoInstance.all.count
    @technologies_count = Technology.all.count
  end

  def search_by_tag(search_text)
    @app_modules = AppModule.tagged_with(search_text)
    @app_roles = AppRole.tagged_with(search_text)
    @applications = Application.tagged_with(search_text)
    @deployments = Deployment.where(id: -1);
    @entities = Entity.tagged_with(search_text)
    @hosts = Host.tagged_with(search_text)
    @lifecycles = Lifecycle.where(id: -1);
    @mainteners = Maintener.tagged_with(search_text)
    @people = Person.tagged_with(search_text)
    @realisations = Realisation.tagged_with(search_text)
    @techno_instances = TechnoInstance.tagged_with(search_text)
    @contracts = Contract.tagged_with(search_text)
    @attribute_types = AttributeType.tagged_with(search_text)
    @contracts = Contract.tagged_with(search_text)
    @discovery_tools = DiscoveryTool.tagged_with(search_text)
    @technologies = Technology.where(id: -1)
    @documents = Document.where(id: -1)
    @document_types = DocumentType.where(id: -1)

    @tags = nil
  end

  def search_by_name(search_text)
    counter = 0

    @app_modules = AppModule.search(search_text)
    objet ||= @app_modules.first
    counter += @app_modules.count

    @app_roles = AppRole.search(search_text)
    objet ||= @app_roles.first
    counter += @app_roles.count

    @applications = Application.search(search_text)
    objet ||= @app_roles.first
    counter += @app_roles.count

    @deployments = Deployment.search(search_text)
    objet ||= @deployments.first
    counter += @deployments.count

    @entities = Entity.search(search_text)
    objet ||= @entities.first
    counter += @entities.count

    @hosts = Host.search(search_text)
    objet ||= @hosts.first
    counter += @hosts.count

    @lifecycles = Lifecycle.search(search_text)
    objet ||= @lifecycles.first
    counter += @lifecycles.count

    @mainteners = Maintener.search(search_text)
    objet ||= @mainteners.first
    counter += @mainteners.count

    @people = Person.search(search_text)
    objet ||= @people.first
    counter += @people.count

    @realisations = Realisation.search(search_text)
    objet ||= @realisations.first
    counter += @realisations.count

    @techno_instances = TechnoInstance.search(search_text)
    objet ||= @techno_instances.first
    counter += @techno_instances.count

    @technologies = Technology.search(search_text)
    objet ||= @technologies.first
    counter += @technologies.count

    @documents = Document.search(search_text)
    objet ||= @documents.first
    counter += @documents.count

    @document_types = DocumentType.search(search_text)
    objet ||= @document_types.first
    counter += @document_types.count

    @contracts = Contract.search(search_text)
    objet ||= @contracts.first
    counter += @contracts.count

    @attribute_types = AttributeType.search(search_text)
    objet ||= @attribute_types.first
    counter += @attribute_types.count

    @attribute_types = AttributeType.search(search_text)
    objet ||= @attribute_types.first
    counter += @attribute_types.count

    @discovery_attributes = DiscoveryAttribute.search(search_text)
    objet ||= @discovery_attributes.first
    counter += @discovery_attributes.count

    @discovery_tools = DiscoveryTool.search(search_text)
    objet ||= @discovery_tools.first
    counter += @discovery_tools.count

    @discoveries = Discovery.search(search_text)
    objet ||= @discoveries.first
    counter += @discoveries.count

    @tags = ActsAsTaggableOn::Tagging.includes(:tag).where(tags: {name: search_text}).map { |tagging| { id: tagging.tag_id, name: tagging.tag.name, note: "Tag" } }.uniq

    if counter==1
      redirect_to controller: objet.class.name.tableize, action: :show, id: objet.id, search: params[:search]
    end
  end

  def search
    # DRY Needed !!!
    if params[:tag] == "true"
      search_by_tag params[:search].downcase
    else
      search_by_name params[:search].downcase
    end
  end

end
