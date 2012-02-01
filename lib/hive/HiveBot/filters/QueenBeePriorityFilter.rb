require 'filters/Filter'

class Hive::QueenBeePriorityFilter < Hive::Filter
  LOGGER = LoggerCreator.createLoggerForClass(Hive::QueenBeePriorityFilter)
  
  def self.purify_moves(board_state, player, moves)
    return if moves.length == 0 
    
    #force queenbee moves
    queen = board_state.get_piece_with_color(player.color, Hive::Piece::QUEEN_BEE)
    if player.turns(board_state) == 3 and not queen.used?
      LOGGER.debug "force all queen moves"
      moves.delete_if {|m| !m.piece.kind_of? Hive::QueenBee}
    end 
        
  end
  
end