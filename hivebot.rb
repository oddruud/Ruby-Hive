$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) )
require 'drb'
require 'bot'   
require 'naivebot'
require 'smartbot'

url ="localhost"
port= "3333"
DRb.start_service 
bot= NaiveBot.new(url,port, "Jimmy")
DRb.thread.join

#TEST

