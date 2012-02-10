require "Common/bot"
require "LoggerCreator"

require "filters/QueenBeePriorityFilter"
require "filters/AttackFilter"
require "filters/DefenseFilter"

class Hive::NaiveBot < Hive::Bot
      include DRbUndumped
  
  #attr_reader :logger
  
  def initialize(name)
    super("Naive Bot:#{name}")   
    @move_filters = [	Hive::QueenBeePriorityFilter, 
    					Hive::DefenseFilter, 
    					Hive::AttackFilter
    				]
  end
 
  #TODO place the queenbee somewhere in first 4 moves
 
  def determine_next_move(board_state)
    @logger.debug "determining move, calculating move for #{@color}.."
    
    pieces = board_state.get_pieces_by_color(@color)
    possible_moves = Array.new()  

      pieces.each do |piece|
        if interesting_piece? board_state, piece 
          puts "#{piece.name} moves...."
          possible_moves += piece.available_moves
        end
      end
    @logger.info "NUM possible Moves #{possible_moves.length}"  
    
    filter_interesting_moves(board_state, possible_moves)
  
    @logger.info "filtered: #{possible_moves.length}"  
    
    raise "#{self} has no moves" if possible_moves.length == 0
    
    #pick a random move: 
    move = possible_moves[ rand(possible_moves.length) ]  
    log_move( move )
    submit_move( move ) 
  
  end
  
  def filter_interesting_moves( board_state, moves )
    @move_filters.each { |filter| filter.purify_moves(board_state, self, moves ) } 
  end
  
  def interesting_piece? (board_state, piece )
    return true
  end
  
  def to_s
  	return "<#{self.class}-#{@name}-#{@color}>"
  end
  
end
