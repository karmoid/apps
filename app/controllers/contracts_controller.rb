class ContractsController < ApplicationController
  def show
    @contract = Contract.find(params[:id])
    @maintener = @contract.maintener
    @app_modules = @contract.app_modules
    @hosts = Host.joins([:contracts, techno_instances: {realisations: [:lifecycle]}]).where(contracts: {id: @contract.id})

    @hostsprod = @hosts.where(lifecycles: {name: "prod"}).distinct
    @hostspprod = @hosts.where(lifecycles: {name: "recette"}).distinct
    @hostsdev = @hosts.where(lifecycles: {name: "dev"}).distinct
    # @hostscount = @hosts.distinct.count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contract }
    end

  end

  def index
    @contracts = Contract.all
  end
end
