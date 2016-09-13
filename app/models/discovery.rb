class Discovery < ActiveRecord::Base
  belongs_to :discovery_tool
  has_many :discovery_attributes
  has_many :discovery_sessions

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "découvertes"
    else
      "découverte"
    end
  end

  def self.changed_details(value, detail_json)
    dynamic_exist = detail_json.count>0
    # puts value.detail unless value.nil?
    db_exist = !value.nil? && JSON.parse(value.detail).count>0
    # logger.info "DYNAMIC : [" + detail_json.to_json + "]"
    # logger.info "DATABASE: [" + value.detail + "]" unless value.nil?
    retour = (dynamic_exist!=db_exist) || (db_exist && (value.detail!=detail_json.to_json))
    # logger.info "Retourne #{retour ? 'oui changé' : 'non inchangé'} avec dynamic_exist=#{dynamic_exist ? 'true' : 'false'} et db_exist=#{db_exist ? 'true' : 'false'}"
    return retour
  end

  def self.build_json(discovery_id,tag,filter,fields)
    out_data = []
    hostid = -1
    discovery_attributes = DiscoveryAttribute.find_by_sql(
        "select * from discovery_attributes where
        discovery_attributes.discovery_id=#{discovery_id} and
        (discovery_attributes.host_id,
        discovery_attributes.attribute_type_id, discovery_attributes.discovery_id,
        discovery_attributes.version) in
        (
        select discovery_attributes.host_id, discovery_attributes.attribute_type_id, discovery_attributes.discovery_id, max(discovery_attributes.version) as high_version
        from discovery_attributes
        where discovery_attributes.attribute_type_id in (#{fields.join(',')})
        group by discovery_attributes.host_id, discovery_attributes.attribute_type_id, discovery_attributes.discovery_id
        union
        select discovery_attributes.host_id, discovery_attributes.attribute_type_id, discovery_attributes.discovery_id, max(discovery_attributes.version)-1 as high_version
        from discovery_attributes
        where discovery_attributes.attribute_type_id in (#{fields.join(',')})
        group by discovery_attributes.host_id, discovery_attributes.attribute_type_id, discovery_attributes.discovery_id
        )
        order by discovery_id,host_id,name,version")

#        where discovery_attributes.name in ('hostesx','ipaddress','hostname','vdisk')
                                              # where(discovery_attributes: {discovery_id: discovery_id}).
                                              # where("discovery_attributes.name in ('hostesx','ipaddress','hostname')").
                                              # group([:host_id, :name]).
                                              # having("version=max(version) or version=max(version)-1").
                                              # order(:host_id, :name, :version)
#  Host.joins(discovery_attributes: :discovery).
#       where(discoveries: {id: 1},discovery_attributes: {name: ["folder","hostesx","ipaddress","fullname"]}).
#       group("hosts.id,discovery_attributes.name,discovery_attributes.version").
#       having("version>=max(version-1)").
#       order("hosts.name,discovery_attributes.name,discovery_attributes.version desc")

    current_item = nil
    attrib_id = nil
    attrib = nil
    discovery_attributes.each do |da|
      # puts "found #{da.value} [#{da.name}]"
      if hostid != da.host.id
        # puts "new host #{da.host_id} name: #{da.host.name}"
        unless current_item.nil?
          if !current_item[:tag].match(/#{filter}/i)
            # puts "FOUND #{filter} in #{current_item[:tag]}"
            out_data.pop
          end
        end
        current_item = {newhost: false,
                        note: da.host.note,
                        host_id: da.host.id,
                        tag: "",
                        data: {
                          host: da.host.name,
                          attributes: []}
                        }
        out_data << current_item
        hostid = da.host.id
        attrib_id = nil
      end
      if (da.name==attrib_id)
        attrib_size = current_item[:data][:attributes].size
        current_item[:data][:attributes][attrib_size-1][:value] = da.value
        current_item[:data][:attributes][attrib_size-1][:detail] = JSON.parse(da.detail)
        current_item[:data][:attributes][attrib_size-1][:changed] = true
        current_item[:data][:attributes][attrib_size-1][:since] = da.created_at
        current_item[:data][:attributes][attrib_size-1][:to] = da.updated_at
        current_item[:tag] = attrib[:value] if attrib[:name]==tag
        # puts "#{da.host.name}: changement #{da.value} remplace #{current_item[:data][:attributes][attrib_size-1][:previous]}"
      else
        attrib = {enum_attr: ApplicationHelper::dbtype_to_enum(da.attribute_type.name),
                    name: da.name, value: da.value, detail: JSON.parse(da.detail),
                    since: da.created_at, to: da.updated_at,
                    changed: false, previous: da.value, detailprev: JSON.parse(da.detail),
                    prev_since: da.created_at, prev_to: da.updated_at,
                  }
        current_item[:tag] = attrib[:value] if attrib[:name]==tag
        current_item[:data][:attributes] << attrib
      end
      attrib_id = da.name
    end
    unless current_item.nil?
      if !current_item[:tag].match(/#{filter}/i)
        # puts "FOUND #{filter} in #{current_item[:tag]}"
        out_data.pop
      end
    end
    return out_data
  end

  def self.analyze(id,discovery_data,save)
    discovery_start = Time.now
    newhost = attribute_changes = 0
    out_data = []
    @discovery = Discovery.find(id)
    discovery_data.each do |data|
      host = Host.find_by_name(data[:host])
      hostnil = host.nil?
      if hostnil
        current_item = {newhost: true, data: data}
        host = Host.create(name: data[:host], note: "créé par découverte") if save
        newhost += 1
      else
        current_item = {newhost: false, note: host.note, host_id: host.id, data: data}
      end
      current_item[:data][:attributes].each do |attrib|
        lib = AttributeType.find_by_name(attrib[:name])

        if hostnil
          value = nil
          host.discovery_attributes.build(attribute_type_id: lib.id,
                                      discovery_id: @discovery.id,
                                      version: 1,
                                      name: attrib[:name],
                                      value: attrib[:value],
                                      detail: attrib[:details].to_json
                                      ) unless !save || lib.nil?
          attribute_changes += 1
        else
          value = DiscoveryAttribute.joins(:host, :discovery).where(discoveries: {id: id}, hosts: {id: host.id}, discovery_attributes: {name: attrib[:name]}).order(created_at: :desc).limit(1).first
        end
        attrib[:lib] = lib.nil? ? attrib[:name] : lib.note
        attrib[:previous] = value.nil? ? nil : value.value
        details_changed = changed_details(value, attrib[:details])
        attrib[:changed] = value.nil? || (value.value != attrib[:value])
        if (save) && (!lib.nil?)
          if (attrib[:changed]) || details_changed
            if (!value.nil?)
              # logger.info "On duplique un enregistrement" if attrib[:enum_attr]==:vdisk
              # try to create a new value (dt_created different)
              value = value.dup
              value.value = attrib[:value]
              value.version += 1
              if details_changed
                # logger.info "Detail modifiés" if attrib[:enum_attr]==:vdisk
                value.detail = attrib[:details].to_json
              end
              attribute_changes += 1
              value.save
              # value.value = attrib[:value]
              # value.version += 1
              # value.save
            else
              host.discovery_attributes.build(attribute_type_id: lib.id,
                                              discovery_id: @discovery.id,
                                              version: 1,
                                              name: attrib[:name],
                                              value: attrib[:value],
                                              detail: attrib[:details].to_json
                                              )
              attribute_changes += 1
              # logger.info "On créé un enregistrement" if attrib[:enum_attr]==:vdisk
            end
          else
            # pas de changement de données, mais on note la durée en jouant
            # avec updated_at
            # vérifier si un save sans réelle modification fait bien un update.
            value.touch
            # autre solution, une instruction SQL pour faire un Update massif
            # mais il faudrait trouver le critère de date pour la sélection
          end
        # current_item[:data][:attributes] << attrib
        end
      end
      out_data << current_item
      host.save unless !save && host.nil?
    end
    @discovery.discovery_sessions.build(from: discovery_start, to: Time.now,
                            newhost: newhost, attribute_changes: attribute_changes, name: @discovery.name,
                            note: @discovery.note).save if save
    puts "* #{newhost} nouveaux objets / #{attribute_changes} attributs modifies."
    return out_data
  end

end
