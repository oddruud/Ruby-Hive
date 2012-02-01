require 'boardstate'
require 'Move/move'
require 'LoggerCreator'
require 'gamehandler'


class Hive::Player
  include DRbUndumped

  attr_accessor :name 
  attr_accessor :gameHandler
  attr_accessor :id 
  attr_reader :color
  attr_reader :logger
  attr_accessor :submitMoveTo
  attr_accessor :submitted_moves
   
  def initialize(name, color = Hive::PieceColor::WHITE)
   @name = name
   setColor(color)
   @logger = LoggerCreator.createLoggerForClass(Hive::Player)
   @submitted_moves = Array.new()
  end

  def setID(id)
    @id= id
  end
  
  def setColor(color)
    @color = color
  end
    
  def gameStarts(message)
    @logger.info "GAME STARTS!"
    @logger.info "#{message}";  
  end
 
  def welcome(message)
    @logger.info "#{message}";  
  end    
   
  def makeMove(board_state)
    @logger.info "player's makemove called"
    submitMove(Hive::Move.new(0,0,0)) 
  end  
  
  def submitMove(move) 
      submitMoveTo.call(self, move)
  end  
  
  def pieces(board_state)
     return board_state.getPiecesByColor(@color)
  end

  
  def turns(board_state) 
    board_state.get_turns(color)
  end 
  
  def color
    return @color 
  end

  def opponentPieces(board_state)
    pieces = []  
    PieceColor::COLORS.each do |color|
      unless color == @color 
        pieces = pieces + board_state.getPiecesByColor(color)
      end
    end
    return pieces
  end
  
  def logMove(move)
    @submitted_moves << move
  end

  
end
