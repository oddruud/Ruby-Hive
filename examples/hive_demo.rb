#$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../lib' ) ) 
require 'rubygems'
require 'hive'

server = Hive::Server.new(3333, true)
window = Hive::GameView.new(server.game_handler)
view_thread = Thread.new {window.show}
server.start_test() 
view_thread.join 
