#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) )
require 'socket'
require 'timeout'
require 'drb'
require 'bot'   
require 'naivebot'
require 'smartbot'

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

#begin
#    timeout(1) do #the server has one second to answer
    client = TCPSocket.new("127.0.0.1", 8899)
#    client.send( "Hello\n" )  
#    str = client.recv( 100 )  
#    end
#rescue
#    puts "error: #{$!}"
#end

DRb.thread.join


