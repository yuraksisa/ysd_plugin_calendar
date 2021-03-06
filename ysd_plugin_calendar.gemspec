Gem::Specification.new do |s|
  s.name    = "ysd_plugin_calendar"
  s.version = "0.1.14"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2014-07-18"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml']
  s.description = "Calendar"
  s.summary = "Calendar"
  s.homepage = "http://github.com/ysd_plugin_calendar"    

  s.add_runtime_dependency "ysd_plugin_auth" # Permissions
  s.add_runtime_dependency "ysd_md_calendar" # Calendar

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "sinatra-r18n"
  s.add_development_dependency "dm-sqlite-adapter" # Model testing using sqlite  

end