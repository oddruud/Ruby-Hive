require "Common/bot"
require "LoggerCreator"

require "filters/QueenBeePriorityFilter"
require "filters/AttackFilter"
require "filters/DefenseFilter"

class NaiveBot < Bot
      include DRbUndumped
  
  #attr_reader :logger
  
  def initialize(name)
    super("Naive Bot:#{name}")   
    @move_filters = [QueenBeePriorityFilter, DefenseFilter, AttackFilter]
  end
 
  #TODO place the queenbee somewhere in first 4 moves
 
  def determineNextMove(board_state)
    @logger.debug "determining move, calculating move for #{@color}.."
    
    pieces = board_state.getPiecesByColor(@color)
    possible_moves = Array.new()  

      pieces.each do |piece|
        if interesting_piece? board_state, piece 
          puts "#{piece.name} moves...."
          possible_moves += piece.availableMoves
        end
      end
  
    filter_interesting_moves(board_state, possible_moves)
  
    @logger.info "NUM possible Moves #{possibleMoves.length}"  
    
    #pick a random move: 
    move = possible_moves[ rand(possible_moves.length) ]  
    logMove( move )
    submitMove( move ) 
  
  end
  
  def filter_interesting_moves( board_state, moves )
    @move_filters.each { |filter| filter.purify(board_state, self, moves ) } 
  end
  
  def interesting_piece? (board_state, piece )
    return true
  end
  
  
end
