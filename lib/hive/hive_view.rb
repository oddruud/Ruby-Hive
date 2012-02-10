#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveServer' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveBot' ) ) 

require 'hive'
require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'gamehandler'
require 'server'
require 'GraphicsView/viewer.rb'

server = Server.new(3333, true)

window = GameView.new(server.game_handler)
view_thread = Thread.new {window.show}

server.start_test() 
view_thread.join 
