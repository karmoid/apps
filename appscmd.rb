# ARGV.each do |arg|
#   puts arg.inspect
# end

def dumpHost(hostname)
  h = hostname.match(/^#(\d*)$/)
  # puts h.inspect
  if h.nil?
    hosts = Host.search(hostname)
  else
    hosts = Host.all.where(id: h[1].to_i)
  end
  puts "\nResultats pour (#{hostname})\n"
  hosts.each do |host|
    puts "* ##{host.id}-#{host.name}: #{host.note}"
    host.techno_instances.each do |ti|
      puts "\t* Service ##{ti.id}-#{ti.name}: #{ti.note}"
    end
    host.contracts.each do |c|
      puts "\t* contrat ##{c.id}-#{c.name}: #{h.nil? ? c.note.split("\n").first : c.note}"
    end
    unless h.nil? && hosts.size>1
      Realisation.joins(:techno_instances).where("techno_instances.host_id in (:host_id,:host_model_id)", {host_id: host.id, host_model_id: host.host_model_id}).
                  distinct.each do |r|
        puts "    ##{r.id}-#{r.name} deploye en #{r.lifecycle.name}"
        r.app_modules.each do |am|
          puts "\tModule applicatif ##{am.id}-#{am.name} de ##{am.application.id}-#{am.application.name}"
        end
        puts "    <#{r.app_modules.size} element(s)>"
        r.techno_instances.each do |tis|
          if tis.host_id==host.id
            puts "\tInstance ##{tis.id}-#{tis.name} (##{tis.technology.id}-#{tis.technology.name})"
          else
            puts "\tInstance du modele #{tis.host.name} #{tis.name} (##{tis.technology.id}-#{tis.technology.name})"
          end
        end
        puts "    <#{r.techno_instances.size} element(s)>"
      end
      puts "\n* --- *\n"
    end
  end
end

def dumpApplication(appname)
  a = appname.match(/^#(\d*)$/)
  if a.nil?
    apps = Application.search(appname)
  else
    apps = Application.all.where(id: a[1].to_i)
  end
  puts "\nResultats pour (#{appname})\n"
  apps.each do |app|
    puts "* ##{app.id}-#{app.name}: #{a.nil? ? app.note.split("\n").first : app.note}"
    puts "  Mainteneur ##{app.maintener.id}-#{app.maintener.name}: #{app.maintener.note}" unless app.maintener.nil?
    app.app_modules.each do |am|
      puts "\t* module ##{am.id}-#{am.name}: #{a.nil? ? am.note.split("\n").first : am.note}"
      am.contracts.each do |c|
        puts "\t  contrat ##{c.id}-#{c.name}: #{a.nil? ? c.note.split("\n").first : c.note}"
      end
    end
    unless a.nil? && apps.size>1
      app.app_modules.each do |am|
        puts "\t * ##{am.id}-#{am.name} (##{am.application.id}-#{am.application.name})"
        am.powers.each do |po|
          puts "\t   Pouvoir ##{po.app_role.id}-#{po.app_role.name}: #{po.app_role.note} / #{po.person.name}: #{po.person.note} "
        end
      end
    end
    puts "\n* --- *\n"
  end
end

def dumpPerson(personname)
  p = personname.match(/^#(\d*)$/)
  if p.nil?
    people = Person.search(personname)
  else
    people = Person.all.where(id: p[1].to_i)
  end
  puts "\nResultats pour (#{personname})\n"
  people.each do |person|
    puts "* ##{person.id}-#{person.name}: #{person.note}"
    unless p.nil?  && people.size>1
      person.entities.each do |e|
        puts "    Entité ##{e.id}-#{e.name}: #{e.note}"
      end
      person.mainteners.each do |m|
        puts "    Mainteneur ##{m.id}-#{m.name}: #{m.note}"
      end
      person.powers.each do |p|
        puts "    Pouvoir ##{p.app_role.id}-#{p.app_role.name}: #{p.app_role.note}"
        p.app_modules.each do |am|
          puts "\t * ##{am.id}-#{am.name} (##{am.application.id}-#{am.application.name})"
        end
        puts "    <#{p.app_modules.size} element(s)>"
      end
    end
    puts "\n* --- *\n"
  end
end

def dumpContrat(contratname)
  c = contratname.match(/^#(\d*)$/)
  if c.nil?
    contrats = Contract.search(contratname)
  else
    contrats = Contract.all.where(id: c[1].to_i)
  end
  puts "\nResultats pour (#{contratname})\n"
  contrats.each do |contrat|
    puts "* ##{contrat.id}-#{contrat.name}: #{contrat.note}"
    puts "  ##{contrat.maintener.id}-#{contrat.maintener.name}: #{contrat.maintener.note}"
    unless p.nil?  && contrats.size>1
      puts puts "\n    *** HOSTS ***" unless contrat.hosts.empty?
      contrat.hosts.each do |h|
        puts "\t * ##{h.id}-#{h.name}: #{h.note}"
      end
      puts "    <#{contrat.hosts.size} element(s)>" unless contrat.hosts.empty?
      puts "\n    *** MODULES ***" unless contrat.app_modules.empty?
      contrat.app_modules.each do |am|
        puts "\t * ##{am.id}-#{am.name} (##{am.application.id}-#{am.application.name})"
      end
      puts "    <#{contrat.app_modules.size} element(s)>" unless contrat.app_modules.empty?
    end
    puts "\n* --- *\n"
  end
end

if ARGV.empty?
  # puts "Arguments :\n\tType d'objet\n\tNom d'objet\n"
  puts "Interactive Kartoqy - C.m. 2018\n"

  loop do
    print "kartoqy command >"
    input = gets.chomp
    command, *params = input.split /\s/
    case command
    when /\Ahelp\z/i
      puts "object_type object_name|#object_id\n\nObject types:\nhost\nperson\napplication\ncontract\n\nex:\n\thost frmon\n\thost #12"
    when /\Ahost\z/i
      dumpHost(params[0])
    when /\Aapplication\z/i
      dumpApplication(params[0])
    when /\Acontract\z/i
      dumpContrat(params[0])
    when /\Aperson\z/i
      dumpPerson(params[0])
    when /\Aquit\z/i
      exit
    when /\Aexit\z/i
      exit
    else puts 'Invalid command'
    end
  end
else
  case ARGV[0].downcase
  when "host"
    dumpHost(ARGV[1])
  when "person"
    dumpPerson(ARGV[1])
  when "application"
    dumpApplication(ARGV[1])
  when "contract"
    dumpContrat(ARGV[1])
  else
    puts "#{ARGV[0]} n'est pas un type connu!"
  end
end
