#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/HiveServer' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/HiveBot' ) ) 

class Hive
end

require 'server'
require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'gamehandler'
require 'GraphicsView/viewer.rb'
require 'boardstate.rb'
require 'player.rb'

#server = Hive::Server.new(3333, true)
#window = Hive::GameView.new(server.game_handler)
#view_thread = Thread.new {window.show}
#server.startTest() 
#view_thread.join 
