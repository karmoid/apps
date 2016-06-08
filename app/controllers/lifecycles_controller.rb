class LifecyclesController < ApplicationController
  def show
    @lifecycle = Lifecycle.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lifecycle }
    end

  end

  def index
    @lifecycles = Lifecycle.all
  end
end
