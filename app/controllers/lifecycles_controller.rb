class LifecyclesController < ApplicationController
  def show
    @lifecycle = Lifecycle.find(params[:id])
    @realisations = @lifecycle.realisations
    @hosts = Host.joins([techno_instances: {realisations: [:lifecycle]}]).where(lifecycles: {id: @lifecycle.id}).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lifecycle }
    end

  end

  def index
    @lifecycles = Lifecycle.all
  end
end
