class DiscoveryAttributesController < ApplicationController
  def show
    @discovery_attribute = DiscoveryAttribute.find(params[:id])

    @discovery = @discovery_attribute.discovery
    @host = @discovery_attribute.host
    @attribute_type = @discovery_attribute.attribute_type
    @attr_type = ApplicationHelper::dbtype_to_enum(@attribute_type.name)
    @details = JSON.parse(@discovery_attribute.detail, symbolize_names: true)
    puts @details.inspect

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discovery_attribute }
    end

  end

  def index
    @discovery_attributes = DiscoveryAttribute.all
  end
end
