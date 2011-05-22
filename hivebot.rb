$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) )
require 'drb'
require 'bot'   
require 'naivebot'
require 'smartbot'

require 'lib_trollop'

#opts = Trollop::options do
#  opt :name, "SUPERBOT"
#end
#puts opts[:name]

if ARGV[0]!=nil
  name = ARGV[0]
else
  name = "BILLY"
end


url ="localhost"
port= "3333"
uri= "druby://#{url}:#{port}"  
system("mkfifo  hivepipe"); 

DRb.start_service 
bot= NaiveBot.new(name)
bot.gameHandler = DRbObject.new nil, uri
bot.gameHandler.addPlayer(bot)


DRb.thread.join


