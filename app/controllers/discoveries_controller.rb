class DiscoveriesController < ApplicationController
  # Pour requête des derniers Attributs
  # Workinprogress :
  # DiscoveryAttribute.joins(:discovery).where(discoveries: {id: disc.id}).updated_between(2.day.ago, Time.now).
  #   group(:host_id, :attribute_type_id).
  #   select(:host_id, :attribute_type_id).having("count(discovery_attributes.id) > 1").count
  #
  # DiscoveryAttribute.joins(:host, :attribute_type).where(hosts: {name: "frmonvdiesx01"},
  #   attribute_types: {name: "hostesx"}).order(updated_at: :desc).map
  #   do |da|
  #     {name: da.host.name ,up: da.updated_at, attr: da.name, value: da.value}
  #   end
  #
  # DiscoveryAttribute.joins(:host, :attribute_type).
  #                     where(
  #                       hosts: {name: "sfrdtcintrdbc01_new_31_07_restore_veeam_replica"},
  #                       attribute_types: {name: "hostesx"}).
  #                     order(updated_at: :desc).
  #                     map do |da|
  #                      {name: da.host.name ,up: da.updated_at, attr: da.name, value: da.value}
  #                     end.
  #                       each {|i| puts "#{i[:up].to_s} - #{i[:attr]} #{i[:value]}" }
  #
  def show
    @discovery = Discovery.find(params[:id])
    @discovery_tool = @discovery.discovery_tool
    @attribute_types = DiscoveryAttribute.joins(:discovery).
                                          where(discoveries: {id: @discovery.id}).
                                          group(:attribute_type).
                                          count
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discovery  }
    end
  end

  def index
    @discoveries = Discovery.all
  end

  def exportfull
    logger.info params[:datacompared].inspect
  end

  def search
    @discovery = Discovery.find(params[:id])
    @discovery_tool = @discovery.discovery_tool
    @discoveries = Discovery.all
    save = params[:iSaveresult]=="yes"

    @dump = ApplicationHelper::getVCenterInfo(@discovery.id, @discovery.target, params["iName"], params["iPassword"])
    @datacompared = Discovery.analyze(@discovery.id,@dump, save)
    # puts @datacompared
    if !params[:export].nil?
      export_csv(@datacompared)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @datacompared }
        format.csv { export_csv(@datacompared) }
      end
    end
  end

  protected

    def export_csv(datacompared)
      filename = filename = I18n.l(Time.now.localtime, :format => :filen) + "-discovery.xls"
      content = "vcentername\tvmname\tfoldername\thostname\tesxname\tsite\tnumEthCards\tindex\tconnected\tmac"+
                "\tvnetwork\tno\tipaddress\tchanged\tprevious\t\n"
      datacompared.each do |dc|
        # puts dc[:data][:host]
        dc[:data][:attributes].each_with_index do |attrib,i|
          if attrib[:enum_attr]==:networkcards
            # puts attrib[:enum_attr].to_s
            attrib[:details].each_with_index do |d,idx|
              site = dc[:data][:hostesx].nil? ? "n/a" : (dc[:data][:hostesx].include? "b4") ? "B4" : (dc[:data][:hostesx].include? "g1") ? "G1" : "n/a"
              content_w = "#{@discovery.target}\t#{dc[:data][:host]}\t#{dc[:data][:folder]}\t"+
                          "#{dc[:data][:fullname]}\t#{dc[:data][:hostesx]}\t#{site}\t#{attrib[:value]}\t"+
                          "#{idx.to_s}\t#{d[:connected] ? "ON" : "OFF"}\t#{d[:mac]}\t#{d[:network]}\t"
              d[:ipaddresses].each_with_index do |ipa,i|
                content += content_w + "#{i.to_s}\t#{ipa[:value]}\t#{attrib[:changed]}\t#{attrib[:previous]}\t\n"
              end
            end
          end
        end
      end
      send_data content, :filename => filename
    end
end
