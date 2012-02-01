require 'hive.rb'

server = Hive::Server.new(3333, true)
window = Hive::GameView.new(server.game_handler)
view_thread = Thread.new {window.show}
server.startTest() 
view_thread.join 
