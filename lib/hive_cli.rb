require '../lib/hive' #replace with hive on publish
require 'optparse'

options = {}
 options[:port] = 3333
 options[:debug] = false

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: HiveServer COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start a hive server"
  opt.separator  "Options"

  opt.on("-p","--port", Integer ,"the portnumber") do |port|
    options[:port] = port || 3333
  end
  opt.on("-d","--debug", "debug") do |debug|
    options[:debug] = true
  end
  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!


case ARGV[0]
when "server"
  	#logger.info "starting hive game server on port #{options[:port]}"
  server= Hive::Server.new(options[:port], options[:debug])
	window = Hive::GameViewSimple.new(server.game)
	view_thread = Thread.new {window.show}
	server.start_test() 
	view_thread.join 
when "test"
	game = Hive::Game.new()	
  game.add_player Hive::NaiveBot.new( "testbot1" )
  game.add_player Hive::NaiveBot.new( "testbot2" )
	#window = Hive::GameView.new( game )
  #view_thread = Thread.new { window.show } 
	Hive::GameViewSimple.open_view( game )
	#game.start()
	
	#view_thread.join
	
end

