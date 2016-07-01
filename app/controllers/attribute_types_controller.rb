class AttributeTypesController < ApplicationController
  def show
    @attribute_type = AttributeType.find(params[:id])

    @discovery_attributes = @attribute_type.discovery_attributes

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attribute_type }
    end

  end

  def index
    @attribute_types = AttributeType.all
  end
end
