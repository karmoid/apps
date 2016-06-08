class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id])
    @powers = Power.joins(:person, :app_role).where(people: {id: @person.id})
    @entities = @person.entities
    @mainteners = @person.mainteners
    @applications = Application.joins(app_modules: :people).where("powers.person_id" => @person.id).distinct
    @app_modules = AppModule.joins(:people).where("powers.person_id" => @person.id).distinct

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end

  end

  def index
    @people = Person.all
  end
end
