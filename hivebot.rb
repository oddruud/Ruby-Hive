$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) )
require 'drb'
require 'bot'   
require 'naivebot'
require 'smartbot'
DRb.start_service


bot= NaiveBot.new("localhost","3333", "Jimmy")


#TEST

