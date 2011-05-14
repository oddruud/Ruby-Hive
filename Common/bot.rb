require 'player'
require 'gamehandler'
class Bot < Player  
    include DRbUndumped
   
  require 'boardstate'
  attr_reader :com 
  
  def initialize(host, port, name)
    super(name) 
    uri= "druby://#{host}:#{port}"  
    gameHandler = DRbObject.new nil, uri
    gameHandler.addPlayer(self)
    gameHandler.hello()
  end
  
  
  

end
