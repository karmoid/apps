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

  def search_by_tag
    @app_modules = AppModule.tagged_with(params[:search])
    @app_roles = AppRole.tagged_with(params[:search])
    @applications = Application.tagged_with(params[:search])
    @deployments = Deployment.where(id: -1);
    @entities = Entity.tagged_with(params[:search])
    @hosts = Host.tagged_with(params[:search])
    @lifecycles = Lifecycle.where(id: -1);
    @mainteners = Maintener.tagged_with(params[:search])
    @people = Person.tagged_with(params[:search])
    @realisations = Realisation.tagged_with(params[:search])
    @techno_instances = TechnoInstance.tagged_with(params[:search])
    @technologies = Technology.where(id: -1);
    @tags = nil
  end

  def search_by_name
    counter = 0

    @app_modules = AppModule.search(params[:search])
    objet ||= @app_modules.first
    counter += @app_modules.count

    @app_roles = AppRole.search(params[:search])
    objet ||= @app_roles.first
    counter += @app_roles.count

    @applications = Application.search(params[:search])
    objet ||= @app_roles.first
    counter += @app_roles.count

    @deployments = Deployment.search(params[:search])
    objet ||= @deployments.first
    counter += @deployments.count

    @entities = Entity.search(params[:search])
    objet ||= @entities.first
    counter += @entities.count

    @hosts = Host.search(params[:search])
    objet ||= @hosts.first
    counter += @hosts.count

    @lifecycles = Lifecycle.search(params[:search])
    objet ||= @lifecycles.first
    counter += @lifecycles.count

    @mainteners = Maintener.search(params[:search])
    objet ||= @mainteners.first
    counter += @mainteners.count

    @people = Person.search(params[:search])
    objet ||= @people.first
    counter += @people.count

    @realisations = Realisation.search(params[:search])
    objet ||= @realisations.first
    counter += @realisations.count

    @techno_instances = TechnoInstance.search(params[:search])
    objet ||= @techno_instances.first
    counter += @techno_instances.count

    @technologies = Technology.search(params[:search])
    objet ||= @technologies.first
    counter += @technologies.count

    @tags = ActsAsTaggableOn::Tagging.includes(:tag).where(tags: {name: params[:search]}).map { |tagging| { id: tagging.tag_id, name: tagging.tag.name, note: "Tag" } }.uniq

    if counter==1
      redirect_to controller: objet.class.name.tableize, action: :show, id: objet.id, search: params[:search]
    end
  end

  def search
    # DRY Needed !!!
    if params[:tag] == "true"
      search_by_tag
    else
      search_by_name
    end
  end

end
