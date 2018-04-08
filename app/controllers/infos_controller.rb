class InfosController < ApplicationController
  def show
    @info = Info.find(params[:id])

    @app_modules = @info.app_modules
    @people = @info.people
    @hosts = @info.hosts

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @info_event }
    end

  end

  def index
    @infos = Info.all
  end
end
