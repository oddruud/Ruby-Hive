$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) )
require 'bot'   
require 'naivebot'
require 'smartbot'

bot= NaiveBot.new()


#TEST

