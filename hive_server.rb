$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveServer' ) )

#system("mkfifo  hivepipe"); 
require "server"  
server= Server.new("localhost", "3333")