require 'player'
require 'gamehandler'
class Bot < Player  
    include DRbUndumped
   
  require 'boardstate'
  attr_reader :com 
  
  def initialize(name)
    super(name) 
  end
    
  def makeMove()
    puts "Bot's makemove called"
    thread = Thread.new{ calculateNextMove();}
    thread.join 
  end  
  
  def calculateNextMove
    puts "calculating move.."
    move= Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
    #emit move
    @gameHandler.moveMade(self, move)
  end
end
