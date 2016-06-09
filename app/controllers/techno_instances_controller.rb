class TechnoInstancesController < ApplicationController
  def show
    @techno_instance = TechnoInstance.find(params[:id])

    @realisations = @techno_instance.realisations.group(:lifecycle).count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @techno_instance }
    end

  end

  def index
    @techno_instances = TechnoInstance.all
  end
end
