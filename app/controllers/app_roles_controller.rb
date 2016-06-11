class AppRolesController < ApplicationController
  def show
    @app_role = AppRole.find(params[:id])
    @people = @app_role.people
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app_role }
    end

  end

  def index
    @app_roles = AppRole.all
  end
end
