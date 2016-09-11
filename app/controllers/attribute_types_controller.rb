class AttributeTypesController < ApplicationController
  def show
    @attribute_type = AttributeType.find(params[:id])
    @filter = params[:iFilter] || ""
    discovery_id = params[:discovery_id]
    unless discovery_id.nil?
      @discovery = Discovery.find(discovery_id)
      @discovery_tool = @discovery.discovery_tool
      @analysed_data = Discovery.build_json(@discovery.id,@attribute_type.name,@filter).group_by {|i| i[:tag]}.map {|k,v| {k: k, v: v.map {|ki| {host: ki[:data][:host], attr: ki[:data][:attributes]} }}}
    end

    # @discovery_attributes = @attribute_type.discovery_attributes

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attribute_type }
    end
  end

  def filter
    @filter = params[:iFilter] || ""
    redirect_to action: :show, iFilter: @filter
  end

  def index
    @attribute_types = AttributeType.all
  end
end
