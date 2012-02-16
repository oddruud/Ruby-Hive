#!/usr/bin/env ruby
require 'rubygems'
require 'hive'
require 'optparse'

if ARGV[0]!=nil
  name = ARGV[0]
else
  name = "BILLY"
end

url ="localhost"
port= "3333"
uri= "druby://#{url}:#{port}"  
system("mkfifo  hivepipe"); 


puts "bot #{name} waiting for server to come online...(press Q to abort)"
DRb.start_service 
bot = Hive::NaiveBot.new(name)

#TODO the game handler should not be a proprty of a bot
bot.game_handler = DRbObject.new nil, uri
bot.game_handler.add_player(bot)

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


