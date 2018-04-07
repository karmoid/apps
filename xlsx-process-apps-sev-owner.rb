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
    puts header.inspect
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
    puts header.inspect
    first_line = false
  else
    data = {}
    break if s.cell(line,1).nil?
    header.each_with_index do |h,i|
      # puts "#{h.inspect} - #{i.inspect}"
      case h[:data]
      when "template"
        data[:template] = s.cell(line,BASE_COL_HOSTS+h[:idx])
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
            data[:lifecycle] = "pprod"
          end
        end
      end
    end

    content[:hosts].push data
    # puts "DESACTIVE pour raison de DATE" if data[:updated].nil? || data[:updated]<DATE_LIMIT
    # unless data[:updated].nil?
    #   puts "on compare #{data[:updated]} et #{DATE_LIMIT}"
    # end
    # puts "DESACTIVE pour raison de TEMPLATE" if data[:template]!=""
    # puts "DESACTIVE pour raison de ITOWNER" if data[:itowner]!=""
  end  
end

puts content.inspect
puts "apps: #{content[:apps].count} et hosts: #{content[:hosts].count}"