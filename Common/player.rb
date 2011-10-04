require 'boardstate'
require 'move'
require 'LoggerCreator'

class Player
  include DRbUndumped

  attr_accessor :name 
  attr_accessor :gameHandler
  attr_accessor :id 
  attr_reader :color
  attr_reader :logger
  attr_accessor :receiverFunction
   
  def initialize(name)
   @name = name
   @logger = LoggerCreator.createLoggerForClass(Player)
  end

  def setID(id)
    @id= id
  end
  
  def setMoveReceiverFunction(&receiverFunction)
    @receiverFunction = receiverFunction  
  end
    
  def gameStarts(message)
    @logger.info "GAME STARTS!"
    @logger.info "#{message}";  
  end
 
  def welcome(message)
    @logger.info "#{message}";  
  end    
   
  def makeMove(boardState)
    @logger.info "player's makemove called"
  end  
  
  def submitMove(move) 
      receiverFunction.call(@id, move)
  end  
  

end
