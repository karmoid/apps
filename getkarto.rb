require "simple-spreadsheet"
require "time"
require "yaml"
require "yaml/store"

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


s = SimpleSpreadsheet::Workbook.read("Applications Final-20171115.xlsx")

s.selected_sheet="Sheet1"

first_line = false

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
servers = {}

i = 0
s.first_row.upto(300) do |line|
  i += 1
  if first_line
    data1 = s.cell(line, 1)
    break if data1.nil? || data1.to_s>"France"
    if data1.to_s.downcase == "france"
      # puts data1.inspect
      applications[s.cell(line,2).to_s.downcase] = [] if applications[s.cell(line,2).to_s.downcase].nil?
      applications[s.cell(line,2).to_s.downcase] << {
        app: s.cell(line,1).to_s,
        type: s.cell(line,3).to_s,
        bizline: s.cell(line,4).to_s,
        dependson: s.cell(line,5).to_s.downcase,
        itowner: s.cell(line,7).to_s.downcase,
        bizowner: s.cell(line,8).to_s.downcase,
        vendor: s.cell(line,9).to_s.downcase,
        servers: []
      }
      [11,13,15].each do |idx|
        applications[s.cell(line,2).to_s.downcase].last[:servers] << s.cell(line,idx).to_s.downcase.split(".").first if !s.cell(line,idx).nil?
      end

      # It Owner
      contacts[s.cell(line,7).to_s.downcase] = [] if contacts[s.cell(line,7).to_s.downcase].nil?
      contacts[s.cell(line,7).to_s.downcase] << {role: "itowner", contact: s.cell(line,7).to_s, app: s.cell(line,2).to_s}
      # biz Owner
      contacts[s.cell(line,8).to_s.downcase] = [] if contacts[s.cell(line,8).to_s.downcase].nil?
      contacts[s.cell(line,8).to_s.downcase] << {role: "bizowner", contact: s.cell(line,8).to_s, app: s.cell(line,2).to_s}
      # Servers
      [11,13,15].each do |i|
        if !s.cell(line,i).nil?
          servers[s.cell(line,i).to_s.downcase] = [] if servers[s.cell(line,i).to_s.downcase].nil?
          servers[s.cell(line,i).to_s.downcase] << {host: s.cell(line,i).to_s, app: s.cell(line,2).to_s}
        end
      end
    end
  end
  first_line = first_line || s.cell(line,1).to_s.downcase=="reporting country"
end
# puts applications.inspect
# puts contacts.inspect
# puts servers.inspect

servers.each do |key,values|
  if key != ""
    servdata = {}
    transco.each do |trans|
      m = trans[:regex].match(key.split(".").first.downcase)
      if !m.nil?
        # puts "#{key} gives #{trans[:service]}"
        servdata[:serveur] = key
        servdata[:service] = trans[:service]
        servdata[:abbr] = trans[:abbr]
        dev = /^(?:eamon|seadtc|sfrhqc|sfrhdqr|sfrdtc|frmon|frpar)(.*)/.match(key.split(".").first.downcase)
        cycle = /^(?:sfrdtv|frmonqa)(.*)/.match(key.split(".").first.downcase)
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
        puts "Serveur: #{key} host service #{trans[:service]} instance #{trans[:abbr]}-#{servdata[:device]}-#{servdata[:lifecycle]}"
        break
      end
    end
    @yamlfile[:serveurs][key.split(".").first.downcase] = servdata
    values.each do |app|
      puts "\t#{app[:app]}"
    end
  end
end

contacts.each do |key,values|
  if key != ""
    puts "Contact: #{key}"
    # checkkey = key
    checkkey = getContactKey(key)
    addContact(checkkey,key)
    # yamlfile[:contacts][checkkey] = checkkey if checkkey!=""
    values.each do |contact|
      addContactRole(checkkey,contact[:role], contact[:app] )
    end
  end
end

applications.each do |key,values|
  puts "Application: #{key}"
  values.each do |application|
    puts "\tType #{application[:type]} / #{application[:bizline]}\n"+
         "\tDepend de #{application[:dependson]}\n"+
         "\tItOwner: #{application[:itowner]} - BusinessOwner: #{application[:bizowner]}\n"+
         "\tFournisseur: #{application[:vendor]}\n"+
         "\tServeurs:"
    addMaintener(key,application[:vendor])
    addApplication(key,application[:type],application[:dependson],application[:itowner],application[:bizowner],application[:vendor])
    application[:servers].each do |server|
      addApplicationServer(key,server)
      puts "\t\t#{server}"
    end
  end
end

puts @yamlfile.inspect

store = YAML::Store.new "karto_ref.yml"

store.transaction do
  store["data"] = @yamlfile
end
