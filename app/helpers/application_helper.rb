module ApplicationHelper

  $enum_attribute_types = {
    ipaddress: "ipaddress",
    snapshotitem: "snapshot",
    snapshotcount: "snapshotcount",
    hosttype: "hosttype",
    cpu: "cpu",
    mem: "mem",
    disk: "disk",
    vmt_version: "vmtlsversion",
    vmt_status: "vmtlsstatus",
    t_status: "toolsstatus",
    networkcards: "networkcard",
    vdisk: "vdisk",
    folder: "folder",
    family: "family",
    fullname: "fullname",
    state: "state",
    hostname: "hostname",
    run_status: "running_status",
    netcard_detail: "netcarddetail",
    network_detail: "networkdetail",
    host: "hostesx"
  }

  def humanize secs
    secs = secs / 60
    [[60, :min], [24, :h], [1000, :j]].inject([]){ |s, (count, name)|
      if secs > 0
        secs, n = secs.divmod(count)
        s.unshift "#{n.to_i} #{name}"
      end
      s
    }.join(' ')
  end

  def self.concatener_dataset(dataset1, dataset2)
    if dataset2.nil?
      dataset1
    else
      dataset1+dataset2
    end
  end

  def concatener_dataset (dataset1, dataset2)
    ApplicationHelper.concatener_dataset(dataset1, dataset2)
  end

  def dbtype_to_enum (value)
    ApplicationHelper.dbtype_to_enum(value)
  end

  def enum_to_dbtype(value)
    ApplicationHelper.enum_to_dbtype(value)
  end

  def self.dbtype_to_enum (value)
    $enum_attribute_types.key(value)
  end

  def self.enum_to_dbtype(value)
    $enum_attribute_types[value]
  end

  def getVCenterInfo(id, url, uname, upwd)
    return ApplicationHelper::getVCenterInfo(id, url, uname, upwd)
  end

  def self.getVCenterInfo(id,url,uname,upwd)
    vim1 = RbVmomi::VIM.connect host: url, ssl: true, insecure: true, user: uname, password: upwd
    dc = vim1.serviceInstance.find_datacenter

    dump = vms(dc.vmFolder)
    dmp_host = hosts(dc.hostFolder.children)
    dump += dmp_host unless dmp_host.nil?
    puts "#{dump.size} objets collectes."
    return dump
  end

  def self.dumpsnapshots(rang, snapshotitem, attributes)
    # puts snapshotitem.name + " le " + snapshotitem.createTime.to_s + " : " + snapshotitem.description
    rang += 1
    attributes << {enum_attr: :snapshotitem, level: rang, name: snapshotitem.name, value: snapshotitem.description, created_at: snapshotitem.createTime.getlocal.to_s}
    unless snapshotitem.nil?
      snapshotitem.childSnapshotList.each do |sn|
        dumpsnapshots(rang, sn, attributes)
      end
    end
  end

  def self.vms(folder) # recursively go thru a folder, dumping vm info
    attribute_list = []
    folder.childEntity.each do |x|
      name, junk = x.to_s.split('(')
      case name
      when "Folder"
        ext_list = vms(x)
         attribute_list += ext_list unless ext_list.nil?
      when "VirtualMachine"
        # puts "#{x.name}"
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
          # pour l'instant comme cela
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

 def self.hosts(children)
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


end
