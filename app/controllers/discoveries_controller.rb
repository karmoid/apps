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
    @discovery_attributes = DiscoveryAttribute.joins(:discovery).
                                                where(discoveries: {id: @discovery.id}).
                                                group("discovery_attributes.id").
                                                having("version=max(version)").
                                                order(:host_id, :attribute_type_id, :id)
#    @analysed_data = Discovery.build_json(@discovery.id).group_by {|i| i[:hostesx]}.map {|k,v| {k: k, v: v.map {|ki| ki[:data][:host]} }}
    @analysed_data = Discovery.build_json(@discovery.id).group_by {|i| i[:hostesx]}.map {|k,v| {k: k, v: v.map {|ki| {host: ki[:data][:host], attr: ki[:data][:attributes]} }}}
# @analysed_data = Discovery.build_json(@discovery.id).group_by {|i| i[:hostesx]}
# data.group_by {|i| i[:hostesx]}.map {|k,v| {k: k, v: v.map {|ki| ki[:data][:host]} }}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discovery  }
    end

  end

  def index
    @discoveries = Discovery.all
  end

  def dumpsnapshots(rang, snapshotitem, attributes)
    # puts snapshotitem.name + " le " + snapshotitem.createTime.to_s + " : " + snapshotitem.description
    rang += 1
    attributes << {enum_attr: :snapshotitem, level: rang, name: snapshotitem.name, value: snapshotitem.description, created_at: snapshotitem.createTime.getlocal.to_s}
    unless snapshotitem.nil?
      snapshotitem.childSnapshotList.each do |sn|
        dumpsnapshots(rang, sn, attributes)
      end
    end
  end

  def vms(folder) # recursively go thru a folder, dumping vm info
    attribute_list = []
    folder.childEntity.each do |x|
      name, junk = x.to_s.split('(')
      case name
      when "Folder"
        ext_list = vms(x)
         attribute_list += ext_list unless ext_list.nil?
      when "VirtualMachine"
        puts "#{x.name}"
        attributes = []
        snapshots = []
        fullname = ""
        unless x.snapshot.nil?
          x.snapshot.rootSnapshotList.each do |sn|
            dumpsnapshots(0, sn, snapshots)
          end
        end
        item = {enum_attr: :snapshotcount, name: ApplicationHelper::enum_to_dbtype(:snapshotcount), value: snapshots.count.to_s, details: []}
        snapshots.each do |d|
          item[:details] << d
        end
        attributes << item

        attributes << {enum_attr: :ipaddress, name: ApplicationHelper::enum_to_dbtype(:ipaddress), value: x.guest.ipAddress.to_s, details: []} unless x.guest.ipAddress.nil?
        attributes << {enum_attr: :hosttype, name: ApplicationHelper::enum_to_dbtype(:hosttype), value: "guest", details: []}
        attributes << {enum_attr: :cpu, name: ApplicationHelper::enum_to_dbtype(:cpu), value: x.summary.config.numCpu.to_s, details: []}
        attributes << {enum_attr: :mem, name: ApplicationHelper::enum_to_dbtype(:mem), value: x.summary.config.memorySizeMB.to_s, details: []}
        unless x.guest.disk.nil?
          item = {enum_attr: :disk, name: ApplicationHelper::enum_to_dbtype(:disk), value: (x.guest.disk.count).to_s, details: []}
          x.guest.disk.each do |d|
            item[:details] << {enum_attr: :disk, name: d.diskPath, value: (d.capacity / 1024 / 1024).to_s}
          end
          attributes << item
        end
        attributes << {enum_attr: :vmt_version, name: ApplicationHelper::enum_to_dbtype(:vmt_version), value: x.guest.toolsVersion, details: []} unless x.guest.toolsVersion.nil?
        attributes << {enum_attr: :vmt_status, name: ApplicationHelper::enum_to_dbtype(:vmt_status), value: x.guest.toolsVersionStatus, details: []} unless x.guest.toolsVersionStatus.nil?
        attributes << {enum_attr: :t_status, name: ApplicationHelper::enum_to_dbtype(:t_status), value: x.guest.toolsStatus, details: []} unless x.guest.toolsStatus.nil?
        attributes << {enum_attr: :vdisk, name: ApplicationHelper::enum_to_dbtype(:vdisk), value: (x.summary.config.numVirtualDisks).to_s, details: []}
        attributes << {enum_attr: :folder, name: ApplicationHelper::enum_to_dbtype(:folder), value: x.parent.name, details: []}
        attributes << {enum_attr: :family, name: ApplicationHelper::enum_to_dbtype(:family), value: x.guest.guestFamily, details: []} unless x.guest.guestFamily.nil?
        attributes << {enum_attr: :fullname, name: ApplicationHelper::enum_to_dbtype(:fullname), value: x.guest.guestFullName, details: []} unless x.guest.guestFullName.nil?
        attributes << {enum_attr: :state, name: ApplicationHelper::enum_to_dbtype(:state), value: x.guest.guestState, details: []} unless x.guest.guestState.nil?
        attributes << {enum_attr: :run_status, name: ApplicationHelper::enum_to_dbtype(:run_status), value: x.guest.toolsRunningStatus, details: []} unless x.guest.toolsRunningStatus.nil?
        unless x.guest.hostName.nil?
          fullname = x.guest.hostName.downcase
          attributes << {enum_attr: :hostname, name: ApplicationHelper::enum_to_dbtype(:hostname), value: fullname, details: []}
        end
        attributes << {enum_attr: :host, name: ApplicationHelper::enum_to_dbtype(:host), value: x.runtime.host.name, details: []} unless x.runtime.host.nil?

        item = {enum_attr: :networkcards, name: ApplicationHelper::enum_to_dbtype(:networkcards),
                      value: x.summary.config.numEthernetCards.to_s,
                      details: []
                    }
        x.guest.net.each_with_index do |gni,idx|
          item_net = {enum_attr: :networkcards, connected: gni.connected, mac: gni.macAddress, network: gni.network, ipaddresses: []}
          gni.ipAddress.each_with_index do |ipa,i|
            item_net[:ipaddresses] << {enum_attr: :ipaddress, value: ipa}
          end
          item[:details] << item_net
          # pour l'innstant comme cela
          # on va créer une table discovery_details ou on pourra mettre ce genre d'inforations
          # en conservant 2 ou 3 versions...
        end
        attributes << item

        # sauver les datastores des VMs
        # puts attributes.inspect
        attribute_list << {host: x.name.downcase, fullname: fullname, hostesx: x.runtime.host.name, folder: x.parent.name, attributes: attributes}
        # return attribute_list if list.count > 2
      end
   end
   return attribute_list
   # Digest::MD5.hexdigest(Marshal::dump(hash.collect{|k,v| [k,v]}.sort{|a,b| a[0] <=> b[0]}))
 end

 def hosts(children)
   host_list = []
   children.each  do |dtc|
     dtc.host.each do |host|
       host_list << {host: host.name.downcase.split(".")[0], fullname: host.name.downcase, folder: "", attributes: [
         {enum_attr: :hosttype, name: ApplicationHelper::enum_to_dbtype(:hosttype), value: "host", details: []},
         {enum_attr: :hostname, name: ApplicationHelper::enum_to_dbtype(:hostname), value: host.name.downcase, details: []},
         {enum_attr: :cpu, name: ApplicationHelper::enum_to_dbtype(:cpu), value: host.hardware.cpuInfo.numCpuCores.to_s, details: []},
         {enum_attr: :mem, name: ApplicationHelper::enum_to_dbtype(:mem), value: (host.hardware.memorySize / 1024 / 1024).to_s, details: []}
         ]}
      end
   end
   return host_list
 end

  def exportfull
    logger.info params[:datacompared].inspect
  end

  def search
    @discovery = Discovery.find(params[:id])
    @discovery_tool = @discovery.discovery_tool
    @discoveries = Discovery.all
    save = params[:iSaveresult]=="yes"

    vim1 = RbVmomi::VIM.connect host: @discovery.target, ssl: true, insecure: true, user: params["iName"], password: params["iPassword"]
    dc = vim1.serviceInstance.find_datacenter

    @dump = vms(dc.vmFolder)
    dmp_host = hosts(dc.hostFolder.children)
    @dump += dmp_host unless dmp_host.nil?
    # @dump = hosts(dc.hostFolder.children)

    # puts @dump.map { |d| d[:host]}.join(", ")

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
      filename = I18n.l(Time.now, :format => :short) + "- discovery.xls"
      content = "vcentername\tvmname\tfoldername\thostname\tesxname\tsite\tnumEthCards\tindex\tconnected\tmac"+
                "\tvnetwork\tno\tipaddress\tchanged\tprevious\t\n"
      datacompared.each do |dc|
        puts dc[:data][:host]
        dc[:data][:attributes].each_with_index do |attrib,i|
          if attrib[:enum_attr]==:networkcards
            puts attrib[:enum_attr].to_s
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
