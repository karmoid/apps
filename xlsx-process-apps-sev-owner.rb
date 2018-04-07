require "simple-spreadsheet"
require "time"
require "yaml"
require "yaml/store"
require 'optparse'

@dowrite = false

parser = OptionParser.new do |options|
  options.on '-w', '--write-data YES', 'Specify Write option' do |arg|
    puts "Arguments were #{arg.inspect}"
    @dowrite = arg.downcase == "yes"
  end
end

parser.parse! ARGV

@reference = {}
@yamlfile = {serveurs: {}, contacts: {}, apps: {}, mainteners: {}}

begin
  @reference = YAML::load(File.open("karto.yml"))
  puts reference.inspect
rescue
  @reference = {serveurs: {}, contacts: {}, apps: {}, mainteners: {}}
end


def getContactKey(value)
  ret = @reference[:contacts][value]
  ret if ret != nil
  value
end

def addContact(key,value)
  @yamlfile[:contacts][key] = {person: value, powers: {}} if @yamlfile[:contacts][key] == nil
end

def addContactRole(key, role, app)
  @yamlfile[:contacts][key][:powers][role] = [] if @yamlfile[:contacts][key][:powers][role].nil?
  @yamlfile[:contacts][key][:powers][role] << app.downcase
end

def addMaintener(app,key)
  key = "undefined" if key == ""
  @yamlfile[:mainteners][key] = {} if @yamlfile[:mainteners][key] == nil
  @yamlfile[:mainteners][key][app] = "defaultmodule" if @yamlfile[:mainteners][key][app] == nil
end

def addApplication(key,type,dependson,itowner,bizowner,vendor)
  @yamlfile[:apps][key] = {app: key, type: type, dependson: dependson, itowner: itowner, bizowner: bizowner, vendor: vendor, servers: []} if @yamlfile[:apps][key] == nil
end

def addApplicationServer(key,serveur)
  @yamlfile[:apps][key][:servers] << serveur.split(".").first.downcase
end


s = SimpleSpreadsheet::Workbook.read("SupportMeeting-final-20180406.xlsx")


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
  {regex: /.*/, service: "undefined", abbr: "undef"}
]

applications = {}
contacts = {}
contracts = {}
servers = {}

BASE_COL_APPS = 8
BASE_COL_HOSTS = 3
DATE_LIMIT = DateTime.new(2018,4,1)


def createContract(name)
  if @dowrite
    Contract.create(name: name, note: "#{name}, contrat cree par script")
  else
    puts "Contrat(#{name}) - Creation desactivee - Option READONLY"
    nil
  end
end

def createPerson(name)
  if @dowrite
    Person.create(name: name, note: "#{name}, personne cree par script")
  else
    puts "Person(#{name}) - Creation desactivee - Option READONLY"
    nil
  end
end

def createLifecycle(name)
  if @dowrite
    Lifecycle.create(name: name, note: "#{name}, lifecycle cree par script")
  else
    puts "Lifecycle(#{name}) - Creation desactivee - Option READONLY"
    nil
  end
end


def createPower(person, approle)
  if @dowrite
    Power.create(person_id: person.id, app_role_id: approle.id, name: "#{person.name}-#{approle.name}")
  else
    puts "Power(#{person.name}-#{approle.name}) - Creation desactivee - Option READONLY"
    nil
  end
end


content = {apps: [], hosts: []}

s.selected_sheet="references"
first_line = true
i = 0
header = []
s.first_row.upto(300) do |line|
  i += 1
  if first_line
    header.push s.cell(line, BASE_COL_APPS)
    # puts "first header #{header.first.inspect}"
    continue if header.first.nil? || header.first.to_s.downcase!="module"
    header.push s.cell(line, BASE_COL_APPS+1)
    header.push s.cell(line, BASE_COL_APPS+2)
    header.push s.cell(line, BASE_COL_APPS+3)
#    puts header.inspect
    first_line = false
  else
    data = {}
    break if s.cell(line,BASE_COL_APPS).nil?
    header.each_with_index do |h,i|
      # puts "#{h.inspect} - #{i.inspect}"
      case h
      when "module"
        data[:module] = s.cell(line,BASE_COL_APPS+i)
      when "criticité"  
        data[:severity] = s.cell(line,BASE_COL_APPS+i)
      when "itowner"  
        data[:itowner] = s.cell(line,BASE_COL_APPS+i)
      when "big update"
        data[:changes] = s.cell(line,BASE_COL_APPS+i)
      end
    end
    content[:apps].push data
  end  
end

s.selected_sheet="itowner"
first_line = true
i = 0
header = []
s.first_row.upto(1500) do |line|
  i += 1
  if first_line
    header << {data: s.cell(line, BASE_COL_HOSTS), idx: 0}
    # puts "first header #{header.first.inspect}"
    #continue if header.first.nil? || header.first.to_s.downcase!="module"
    header << {data: s.cell(line, BASE_COL_HOSTS+8), idx: 8}
    header << {data: s.cell(line, BASE_COL_HOSTS+9), idx: 9}
    header << {data: s.cell(line, BASE_COL_HOSTS+10), idx: 10}
    header << {data: s.cell(line, BASE_COL_HOSTS+11), idx: 11}
    header << {data: s.cell(line, BASE_COL_HOSTS+12), idx: 12}
    header << {data: s.cell(line, BASE_COL_HOSTS+13), idx: 13}
    header << {data: s.cell(line, BASE_COL_HOSTS+14), idx: 14}
    header << {data: s.cell(line, BASE_COL_HOSTS+15), idx: 15}
#    puts header.inspect
    first_line = false
  else
    data = {}
    break if s.cell(line,1).nil?
    header.each_with_index do |h,i|
      # puts "#{h.inspect} - #{i.inspect}"
      case h[:data]
      when "template"
        data[:template] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "critical"
        data[:critical] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "find-modulecrit"
        data[:criticalapp] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "itowner"  
        data[:itowner] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "BigUpdate"
        data[:changes] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "appname"
        data[:module] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "find-owner"
        data[:owner] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "updated_at"
        data[:updated] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      when "Host repeat"
        data[:host] = s.cell(line,BASE_COL_HOSTS+h[:idx])
      end
    end
    unless data[:updated].nil? || data[:updated]<DATE_LIMIT || data[:template]!="" || data[:itowner]!=""
      transco.each do |trans|
        m = trans[:regex].match(data[:host].split(".").first.downcase)
        if !m.nil?
          # puts "#{key} gives #{trans[:service]}"
          data[:service] = trans[:service]
          data[:abbr] = trans[:abbr]
          dev = /^(?:eamon|seadtc|sfrhqc|sfrhdqr|sfrdtc|frmon|frpar)(.*)/.match(data[:host].split(".").first.downcase)
          cycle = /^(?:sfrdtv|frmonqa|fromnd)(.*)/.match(data[:host].split(".").first.downcase)
          if dev.nil?
            data[:device] = data[:host].split(".").first.downcase
          else
            data[:device] = dev[1]
          end
          if cycle.nil?
            data[:lifecycle] = "prod"
          else
            data[:lifecycle] = "recette"
          end
          content[:hosts].push data
          break
        end
      end
    end

    # puts "DESACTIVE pour raison de DATE" if data[:updated].nil? || data[:updated]<DATE_LIMIT
    # unless data[:updated].nil?
    #   puts "on compare #{data[:updated]} et #{DATE_LIMIT}"
    # end
    # puts "DESACTIVE pour raison de TEMPLATE" if data[:template]!=""
    # puts "DESACTIVE pour raison de ITOWNER" if data[:itowner]!=""
  end  
end

# puts content.inspect

puts "Script is in #{@dowrite ? 'WRITE' : 'READ'} mode"
puts "apps: #{content[:apps].count} et hosts: #{content[:hosts].count}"

puts "processing Applications..."
ITOWNER = AppRole.find_by_name("itowner")
unless ITOWNER.nil?
  content[:apps].each_with_index do |app,i|
    aarr = app[:module].split("|")
    # Application Stuff
    a = Application.find_by_name(aarr.first)
    if a.nil?
      if @dowrite
        a = Application.create(name: aarr.first, note: "Application cree par Script")
        puts "Application #{aarr.first} creee avec l'id ##{a.id}"
  #      break
      else
        puts "Application #{aarr.first} non trouvee"
      end
    end
    # App_module stuff
    a = Application.find_by_name(aarr.first)
    unless a.nil?
      am = a.app_modules.find_by_name(aarr.last)
      if am.nil?
        if @dowrite
          am = a.app_modules.build(name: aarr.last, note: "AppModule de #{aarr.first} cree par Script")
          am.save
          puts "AppModule #{aarr.last} cree avec l'id ##{am.id}" 
  #        break
        else
          puts "Module applicatif #{aarr.last} non trouve"
        end
      end
      unless am.nil?
        # contract stuff
        c = Contract.find_by_name(app[:severity])
        if c.nil?
          puts "Severity: #{app[:severity]} inconnue"
          c = createContract(app[:severity])
        end
        unless c.nil?
          if !c.app_modules.find(am)
            if @dowrite
              c.app_modules << am
              puts "Added Severity #{c.name} to AppModule #{am.application.name} / #{am.name}"
            else
              puts "Unable to add Severity #{c.name} to AppModule #{am.application.name} / #{am.name}. READONLY"
            end
          end  
        else  
          puts "Unable to add Severity #{app[:severity]} to AppModule #{am.application.name} / #{am.name}. UNKNOWN !"
        end
        # Person stuff
        p = Person.find_by_name(app[:itowner])
        if p.nil?
          puts "itowner: #{app[:itowner]} inconnu"
          p = createPerson(app[:itowner])
        end
        unless p.nil?
          pw = Power.joins(:person, :app_role).where(person_id: p.id, app_role_id: ITOWNER.id).first
          if pw.nil?
            puts "Power itowner for #{p.name} unknown"
            pw = createPower(p,ITOWNER)
          end  
          unless pw.nil?
            # puts "ITOWNER: #{ITOWNER.id}-#{ITOWNER.name}, power:#{pw.id}-#{pw.name}, appmodule:#{am.id}-#{am.name}"
            ito_app = Power.joins(:app_role, :app_modules).where(app_roles: {id: ITOWNER.id}, app_modules: {id: am.id})
            found = false
            ito_app.each_with_index do |pow,i|
              # puts "Find itowner #{pow.id}-#{pow.name} versus #{pw.id}-#{pw.name}"
              found = found || pow.id == pw.id
            end  
            # on ne l'a pas trouvé
            if !found
              # maison en a trouvé d'autres !
              if !ito_app.empty?
                ito_app.each_with_index do |pow,i|
                  puts "On supprime le itowner #{pow.name} de AppModule #{am.application.name} / #{am.name}"
                  am.powers.delete(pow) if @dowrite
                end  
              end
              puts "on ajoute le power #{pw.name} à AppModule #{am.application.name} / #{am.name}"
              am.powers << pw if @dowrite
            end
          else  
            puts "Unable to add itowner #{app[:itowner]} to AppModule #{am.application.name} / #{am.name}. UNKNOWN !"
          end
        else  
          puts "Unable to add itOwner #{app[:itowner]} to AppModule #{am.application.name} / #{am.name}. UNKNOWN !"
        end
      else
        puts "itwoner/contracts processing aborted : no Application or AppModule for #{aarr.first} / #{aarr.last}"  
      end
    else
      puts "module processing aborted : no Application for #{aarr.first}"  
    end
  end
else
  puts "Reference Data missing : AppRole 'itowner' !"
end

  # puts host.inspect

  # data[:critical] - Niveau souhaité
  # data[:criticalapp] - NIveau par défaut
  # data[:module] - Application | Module
  # data[:owner] - ITOwner souhaité (warning si différent)
  # data[:updated] - Date de mise à jour
  # data[:host] - Nom de la machine
  # data[:service] - Service d'après son nom
  # data[:abbr] - Abbréviation du service
  # data[:device] - Nom court de la machine
  # data[:lifecycle] - Production ou pas

puts "processing Hosts..."
content[:hosts].each_with_index do |host,i|
  h = Host.find_by_name(host[:host])
  unless h.nil? || host[:module].nil? || (host[:module]=="")
    aarr = host[:module].split("|")
    # Application Stuff
    a = Application.find_by_name(aarr.first)
    am = nil
    unless a.nil?
      am = a.app_modules.find_by_name(aarr.last)
    end
    if am.nil? || a.nil?
      puts "Impossible de charger #{aarr.first} /  #{aarr.last}"
      break
    end
    puts "processing #{h.id}-#{h.name} > #{a.id}-#{a.name} / #{am.id}-#{am.name}"
    puts "Contrat - Data was Default:#{host[:criticalapp]} / Set:#{host[:critical]}"
    contrat_name = host[:critical].to_s=="" ? host[:criticalapp] : host[:critical]
    c = Contract.find_by_name(contrat_name)
    if !c.nil?
      puts "Contrat allocated : #{c.id}-#{c.name}"
    else
      puts "Creation d'un contrat inconnu #{contrat_name}"  
      c = createContract(contrat_name)
      break
    end
    if c.nil?
      puts "impossible de charger le contrat #{contrat_name}"
      break
    end

    lc = Lifecycle.find_by_name(host[:lifecycle])
    if !lc.nil?
      puts "Lifecycle allocated : #{lc.id}-#{lc.name}"
    else
      puts "Creation d'un lifecycle inconnu #{host[:lifecycle]}"  
      lc = createLifecycle(host[:lifecycle])
      break
    end
    if c.nil?
      puts "impossible de charger le contrat #{contrat_name}"
      break
    end


    contrats = Contract.joins(:hosts).where(hosts: {id: h.id}).where("contracts.name like 'eval-%'")
    found = false
    contrats.each_with_index do |contrat,ic|  
      found = found || contrat.id == c.id
    end
    # on ne l'a pas trouvé
    if !found
      # maison en a trouvé d'autres !
      if !contrats.empty?
        contrats.each_with_index do |contrat,i|
          puts "On supprime le contrat #{contrat.name} du Host #{h.id}-#{h.name}"
          h.contracts.delete(contrat) if @dowrite
        end  
      end
      puts "on ajoute le contrat #{c.name} au Host #{h.id}-#{h.name}"
      h.contracts << c if @dowrite
    end
    realisations = Realisation.joins(:app_modules, techno_instances: :host ).
                               where(hosts: {id: h.id}).
                               where(app_modules: {id: am.id})
    #realisations.each_with_index do |real,i|
    #  puts "#{real.id}-#{real.name}"
    #end
    # Si on trouve des realisation sur le Host et la même application, le boulot est déjà fait, on passe
    if realisations.empty? 
      techno = host[:abbr]=="undef" ? "application" : host[:service]
      abbr = host[:abbr]=="undef" ? "app" : host[:abbr]
      t = Technology.find_by_name(techno)
      unless t.nil?
        ti = h.techno_instances.where(technology_id: t.id).first
        unless ti.nil?
          puts "on trouve la bonne techno instance pour #{h.id}-#{h.name} / #{t.id}-#{t.name} - #{ti.id}-#{ti.name}"
        end
        if ti.nil?
          ti = h.techno_instances.first 
          unless ti.nil?
            t = ti.technology
            puts "on prend la premiere techno instance pour #{h.id}-#{h.name} / #{t.id}-#{t.name} - #{ti.id}-#{ti.name}"
          end
        end  
        if ti.nil? && @dowrite
          puts "on cree une nouvelle instance pour #{h.id}-#{h.name} / #{t.id}-#{t.name} - nom: #{abbr}-#{host[:device]}"
          ti = TechnoInstance.create(name: "#{abbr}-#{host[:device]}", technology: t, host: h, note: "instance cree par script")
          break
        end
        if ti.nil?
          puts "impossible de continuer, pas d'instance techno"
          break
        end
        if @dowrite
          r = realisations.create(name: "#{ti.name}-#{lc.name=='prod' ? 'prod' : 'pprod'}", 
                                    note: "realisation creee par script pour #{h.name} vers #{a.name}/#{am.name}", 
                                    lifecycle: lc)
          puts "realisation #{r.id}-#{r.name} cree. #{r.note}"
          am.realisations << r
          ti.realisations << r
          # break
        else
          puts "impossible de relier l'application à l'hote. Mode READONLY"  
        end
      else
        puts "Technology #{techno} inconnue"
        break
      end  
    end 
  else
    if h.nil?
      puts "host introuvable #{host[:host]}"
      break
    end
    puts "Ligne #{i} - Champ application/module vide, Next..."  
  end
end

