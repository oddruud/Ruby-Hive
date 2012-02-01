require 'Insects/piece'

class Hive::QueenBee < Hive::Piece

def initialize(board_state, id)
  super(board_state, id) 
  raise "id of qieen not correct" unless Hive::Piece.valid_id?(id) 
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  moves += Hive::QueenBee.availableBoardMoves( self ) if used? and movable?
 return moves
end

def self.availableBoardMoves(queenbee)
  moves = Array.new()
  queenbee.touch do
    queenbee.forEachAdjacentSlot do |slot|    
      moves << Hive::Move.new(queenbee , slot)
    end  
 end
 queenbee.logger.info "board moves: #{moves.length}"
 return moves
end

    
end
