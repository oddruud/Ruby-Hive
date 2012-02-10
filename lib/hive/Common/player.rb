require 'boardstate'
require 'Move/move'
require 'LoggerCreator'
require 'gamehandler'


class Hive::Player
  include DRbUndumped

  attr_accessor :name 
  attr_accessor :game_handler
  attr_accessor :id 
  attr_reader :color
  attr_reader :logger
  attr_accessor :submit_move_to
  attr_accessor :submitted_moves
   
  def initialize(name, color = Hive::PieceColor::WHITE)
   @name = name
   set_color(color)
   @logger = LoggerCreator.create_logger_for_class(Hive::Player)
   @submitted_moves = Array.new()
  end

  def set_i_d(id)
    @id= id
  end
  
  def set_color(color)
    @color = color
  end
    
  def game_starts(message)
    @logger.info "GAME STARTS!"
    @logger.info "#{message}";  
  end
 
  def welcome(message)
    @logger.info "#{message}";  
  end    
   
  def make_move(board_state)
    @logger.info "player's makemove called"
    submit_move(Hive::Move.new(0,0,0)) 
  end  
  
  def set_submit_function proc 
  	@submit_move_to = proc
  end 
  
  def submit_move(move) 
      submit_move_to.call(self, move)
  end  
  
  def pieces(board_state)
     return board_state.get_pieces_by_color(@color)
  end

  
  def turns(board_state) 
    board_state.get_turns(color)
  end 
  
  def color
    return @color 
  end

  def opponent_pieces(board_state)
    pieces = []  
    PieceColor::COLORS.each do |color|
      unless color == @color 
        pieces = pieces + board_state.get_pieces_by_color(color)
      end
    end
    return pieces
  end
  
  def log_move(move)
    @submitted_moves << move
  end

  
end
