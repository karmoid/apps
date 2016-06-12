class DocumentsController < ApplicationController
  def show
    @document = Document.find(params[:id])
    @document_type = @document.document_type

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end

  end

  def index
    @documents = Document.all
  end

end
