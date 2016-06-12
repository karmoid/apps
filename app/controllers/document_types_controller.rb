class DocumentTypesController < ApplicationController
  def show
    @document_type = DocumentType.find(params[:id])
    @documents = @document_type.documents

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document_type }
    end

  end

  def index
    @document_types = DocumentType.all
  end
end
