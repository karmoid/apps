class DiscoveryToolsController < ApplicationController
  def show
    @discovery_tool = DiscoveryTool.find(params[:id])

    @discoveries = @discovery_tool.discoveries

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discovery_tool }
    end

  end

  def index
    @discovery_tools = DiscoveryTool.all
  end
end
