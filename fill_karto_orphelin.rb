require 'optparse'

@dowrite = false


parser = OptionParser.new do |options|
  options.on '-w', '--write-data YES', 'Specify Write option' do |arg|
    puts "Arguments were #{arg.inspect}"
    @dowrite = arg.downcase == "yes"
  end
end

parser.parse! ARGV

puts "There are #{Host.count} hosts" # I have a hosts model
puts "Script is in #{@dowrite ? 'WRITE' : 'READ'} mode"

NOTE_DEF = "Cree automatiquement depuis fill quick"

@myLifecycle = [
  "pprod",
  "prod"
]

@myTechnology = [
  "application",
  "database",
  "applicationsrv",
  "filesharing",
  "website",
  "gateway",
  "filexfer",
  "undefined"
]

@myAppRole = [
  "itowner",
  "bizowner"
]

def check_techno
  @myTechnology.each do |techno|
    dbt = Technology.find_by_name(techno)
    if dbt.nil?
      puts "Technology [#{techno}] doesn't exist"
      Technology.create(name: techno, note: NOTE_DEF) if @dowrite
    end
  end
end

def check_lifecycle
  @myLifecycle.each do |lifec|
    dbl = Lifecycle.find_by_name(lifec)
    if dbl.nil?
      puts "Lifecycle [#{lifec}] doesn't exist"
      Lifecycle.create(name: lifec, note: NOTE_DEF) if @dowrite
    end
  end
end

def check_app_role
  @myAppRole.each do |role|
    dbr = AppRole.find_by_name(role)
    if dbr.nil?
      puts "App Role [#{role}] doesn't exist"
      AppRole.create(name: role, note: NOTE_DEF) if @dowrite
    end
  end
end


def check_karto
  transco = [
    {regex: /.*dta\d\d?$/, service: "database", abbr: "db"},
    {regex: /.*db.?\d\d?$/, service: "database", abbr: "db"},
    {regex: /.*fls\d\d?$/, service: "filesharing", abbr: "fs"},
    {regex: /.*app\d\d?$/, service: "applicationsrv", abbr: "appsrv"},
    {regex: /.*web\d\d?$/, service: "website", abbr: "web"},
    {regex: /.*gw\d\d?$/, service: "gateway", abbr: "gtw"},
    {regex: /.*gtw\d\d?$/, service: "gateway", abbr: "gtw"},
    {regex: /.*ftp\d\d?$/, service: "filexfer", abbr: "xfer"},
    {regex: /.*etl\d\d?$/, service: "application", abbr: "app"},
    {regex: /.*/, service: "application", abbr: "app"}
  ]

  # check_techno
  # check_lifecycle
  # check_app_role
  puts "Hosts Count:#{Host.count} vs Instances Count:#{TechnoInstance.count}"


  # puts "Hosts without model:#{Host.where(host_model_id: nil).count} and Not:#{Host.where.not(host_model_id: nil).count}"
  #
  # # hosts = (Host.where(host_model_id: nil)-Host.joins(:techno_instances)).joins(:discovery_attributes).where('max discovery_attributes.dt_updated>current_date-60')
  # hosts = Host.joins(:discovery_attributes).where(host_model_id: nil).select('hosts.id,max(discovery_attributes.updated_at)').having('max(discovery_attributes.updated_at)>current_date-60').group('hosts.id')-Host.joins(:techno_instances)
  # puts "processing #{hosts.count} hosts"
  # hosts.each_with_index do |h,i|
  #   host = Host.find(h)
  #   # puts "#{i}: #{host.name}\t##{host.id}\tNoInstance\t#{host.host_model.nil? ? "" : host.host_model.name}"
  #   exit if host.techno_instances.count>0
  #   exit unless host.host_model_id.nil?
  #   key = host.name
  #   servdata = {}
  #   transco.each do |trans|
  #     m = trans[:regex].match(key.split(".").first.downcase)
  #     if !m.nil?
  #       # puts "#{key} gives #{trans[:service]}"
  #       servdata[:serveur] = key
  #       servdata[:service] = trans[:service]
  #       servdata[:abbr] = trans[:abbr]
  #       dev = /^(?:eamon|seadtc|sfrhqc|sfrhdqr|sfrdtc|frmon|frpar)(.*)/.match(key.split(".").first.downcase)
  #       cycle = /^(?:sfrdtv|frmonqa|fromnd)(.*)/.match(key.split(".").first.downcase)
  #       if dev.nil?
  #         servdata[:device] = key.split(".").first.downcase
  #       else
  #         servdata[:device] = dev[1]
  #       end
  #       if cycle.nil?
  #         servdata[:lifecycle] = "prod"
  #       else
  #         servdata[:lifecycle] = "pprod"
  #       end
  #       servdata[:id] = host.id
  #       puts servdata.inspect
  #       # puts "Serveur: #{key} host service #{trans[:service]} instance #{trans[:abbr]}-#{servdata[:device]}-#{servdata[:lifecycle]}"
  #       if @dowrite
  #         lc = Lifecycle.find_by_name(servdata[:lifecycle])
  #         s = Technology.find_by_name(servdata[:service])
  #         ti = host.techno_instances.build(name: "#{servdata[:abbr]}-#{servdata[:device]}", note: "instance de #{servdata[:service]} sur #{servdata[:serveur]}", technology: s)
  #         r = Realisation.create(name: "#{servdata[:abbr]}-#{servdata[:device]}-#{servdata[:lifecycle]}", note: "realisation de #{servdata[:lifecycle]} pour le service #{servdata[:service]} sur #{servdata[:serveur]}", lifecycle: lc).techno_instances << ti
  #         # exit
  #       end
  #       break
  #     end
  #   end
  # end

  hosts = Host.joins(:discovery_attributes).where(host_model_id: nil).select('hosts.id,max(discovery_attributes.updated_at)').having('max(discovery_attributes.updated_at)>current_date-60').group('hosts.id')-Host.joins(techno_instances: :realisations)
  puts "processing #{hosts.count} hosts"
  hosts.each_with_index do |h,i|
    host = Host.find(h)
    break if host.techno_instances.count==0
    puts "#{i}: #{host.name}\t##{host.id}\tNoInstance\t#{host.host_model.nil? ? "" : host.host_model.name} / Instance #1:#{host.techno_instances.first.name}"
    exit unless host.host_model_id.nil?
    key = host.name
    ti = host.techno_instances.first
    service = ti.technology.name
    servdata = {}
    transco.each do |trans|
      if  trans[:service]==service.downcase
        # puts "#{key} gives #{trans[:service]}"
        servdata[:serveur] = key
        servdata[:service] = trans[:service]
        servdata[:abbr] = trans[:abbr]
        dev = /^(?:eamon|seadtc|sfrhqc|sfrhdqr|sfrdtc|frmon|frpar)(.*)/.match(key.split(".").first.downcase)
        cycle = /^(?:sfrdtv|frmonqa|fromnd)(.*)/.match(key.split(".").first.downcase)
        if dev.nil?
          servdata[:device] = key.split(".").first.downcase
        else
          servdata[:device] = dev[1]
        end
        if cycle.nil?
          servdata[:lifecycle] = "prod"
        else
          servdata[:lifecycle] = "pprod"
        end
        servdata[:id] = host.id
        puts servdata.inspect
        # puts "Serveur: #{key} host service #{trans[:service]} instance #{trans[:abbr]}-#{servdata[:device]}-#{servdata[:lifecycle]}"
        if @dowrite
          lc = Lifecycle.find_by_name(servdata[:lifecycle])
          r = Realisation.create(name: "#{servdata[:abbr]}-#{servdata[:device]}-#{servdata[:lifecycle]}", note: "realisation de #{servdata[:lifecycle]} pour le service #{servdata[:service]} sur #{servdata[:serveur]}", lifecycle: lc).techno_instances << ti
          # exit
        end
        break
      end
    end
  end
end

check_karto
