class EntitiesController < ApplicationController
  def show
    @entity = Entity.find(params[:id])

    @people = @entity.people

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entity }
    end

  end

  def index
    @entities = Entity.all
  end
end
