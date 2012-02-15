$:.push File.expand_path("../lib", __FILE__)
require "hive/version"

Gem::Specification.new do |s|
  s.name        = 'hive_boardgame_framework'
  s.version     = Hive::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2012-01-31'
  s.summary     = "Hive Boardgame Framework"
  s.description = "A framework for the hive boardgame featuring a game server, a bot base class and a graphical view"
  s.authors     = ["Ruud op den Kelder"]
  s.email       = 'oddruud@gmail.com'
  s.homepage    = 'https://github.com/oddruud/Hive-Boardgame-Framework'
  
  s.rubyforge_project = "hive_boardgame_framework"
 
  	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")	
	s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
	s.require_paths = ["lib"]
  
  
  s.add_dependency "optparse"
  s.add_dependency "logger"
  s.add_dependency "gosu"
end
