class TechnologiesController < ApplicationController
  def show
    @technology = Technology.find(params[:id])

    @techno_instances = @technology.techno_instances
    @hosts = Host.joins(techno_instances: :technology).where(technologies: {id: @technology.id})
    @realisations = Realisation.joins(techno_instances: :technology).where(technologies: {id: @technology.id}).group(:lifecycle).count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @technology }
    end

  end

  def index
    @technologies = Technology.all
  end
end
