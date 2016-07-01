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

end
