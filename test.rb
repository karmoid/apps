puts "set ENV upwd to proceed !" if ENV["upwd"].nil?
puts "**Demarrage**"
unless ENV["upwd"].nil?
  puts "Nous recherchons les vCenter enregistres"
  DiscoveryTool.find_by_name("vcenter").discoveries.each do |d|
    puts "#{d.name} [#{d.note}] on #{d.target} with #{d.credential}"
    # if d.name=="horizonpodb4"
      dump = ApplicationHelper::getVCenterInfo(d.id, d.target, d.credential, ENV["upwd"])
      puts "* Debut de sauvegarde des donnees"
      Discovery.analyze(d.id,dump,true)
      puts "* Sauvegarde des donnees terminee."
    # end
  end
end
puts "**Fin**"
