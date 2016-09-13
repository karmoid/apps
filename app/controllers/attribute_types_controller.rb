class AttributeTypesController < ApplicationController
  def show
    puts params.inspect
    @attribute_type = AttributeType.find(params[:id])
    @filter = params[:iFilter] || ""
    @reference = params[:iReference] || ""
    @tabular = params[:iTabular] || ""
    @champs = params[:iFields] || []
    @champs.push @attribute_type.id.to_s
    discovery_id = params[:discovery_id]
    unless discovery_id.nil?
      @discovery = Discovery.find(discovery_id)
      @discovery_tool = @discovery.discovery_tool
      @discovery_sessions = DiscoverySession.joins(:discovery).where(discoveries: {id: @discovery.id}).order(created_at: :desc)
      @attribute_types = AttributeType.joins(:discovery_attributes).where(discovery_attributes: {discovery: @discovery.id }).where('attribute_types.id <> ?',@attribute_type.id).distinct
      @analysed_data = Discovery.build_json(@discovery.id,@attribute_type.name,@filter,@champs).group_by {|i| i[:tag]}.map {|k,v| {k: k, v: v.map {|ki| {host: ki[:data][:host], attr: ki[:data][:attributes]} }}}
    end

    # @discovery_attributes = @attribute_type.discovery_attributes
    if !params[:export].nil?
      export_csv(@analysed_data)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @attribute_type }
      end
    end
  end

  def filter
    redirect_to discovery_attribute_type_path(request.parameters.except(:controller, :action, :utf8, :commit).except(:authenticity_token))
  end

  def index
    @attribute_types = AttributeType.all
  end

  protected

    def export_csv(datacompared)
      filename = I18n.l(Time.now, :format => :short) + "- attribute_type.xls"
      # h_content = "#{@attribute_type.name}\tprevious\tsince\tto\tprevious\t\n"
      content = h_content = h2_content = ""
      header_columns = []
      headerdone = false
      datacompared.each do |root|
        #puts "#{root[:k]}: #{root[:v].inspect}"
        root[:v].each_with_index do |leaf,i|
          w_content = i.to_s+"\t"+leaf[:host]+"\t"
          f_content = l_content = ""
          data_columns = []
          base_found = false
          leaf[:attr].each do |item|
            if ApplicationHelper::enum_to_dbtype(item[:enum_attr])==@attribute_type.name
              h_content += "#{item[:name]}\tprevious\tsince\tto\thost\t" unless headerdone
              f_content = "#{item[:value]}\t#{(item[:changed] ? item[:previous] : '')}\t"+
                          "#{item[:since]}\t#{item[:to]}\t#{leaf[:host]}\t"
              base_found = true
            else
              if header_columns.index(item[:name]).nil?
                header_columns.push item[:name]
                data_columns.push item[:value]
              else
                data_columns[header_columns.index(item[:name])] = item[:value]
              end
            end
          end
          if !base_found
            h_content ||= "#{item[:name]}\tprevious\tsince\tto\thost\t"
            f_content = "\t\t\t\t\t"
          end
          headerdone = true
          l_content = data_columns.join("\t")+"\t"
          # h2_content += "#{item[:name]}\t" unless headerdone
          content += f_content + l_content + "\n"
        end
      end
      h2_content = header_columns.join("\t")+"\t"
      send_data "#{h_content}#{h2_content}\n#{content}", :filename => filename
    end
end
