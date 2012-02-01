require 'Insects/piece'
class Hive::Mosquito < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used? 
  moves += Hive::Mosquito.availableBoardMoves(self)  if used?
 return moves
end
 
# WHITE_MOSQUITO moves....
# [16:04:37] FATAL-GameHandler: move failed: stack level too deep
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:135:in `neighbourCoordinates'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:113:in `neighbourCoords'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:162:in `forEachNeighbourCoordinate'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:160:in `each'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:160:in `forEachNeighbourCoordinate'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:212:in `forEachAdjacentSlot' 
  
#WHITE_MOSQUITO moves....
#[21:45:05] FATAL-GameHandler: move failed: stack level too deep
#/Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:87:in `setBoardPosition' 
     
     
#stack level too deep
def self.availableBoardMoves(mosquito)  
  moves = Array.new()
    mosquito.forEachAdjacentPiece do |neighbour|
        #moves += neighbour.class.availableBoardMoves( mosquito ) unless neighbour.kind_of? Mosquito 
    end
  mosquito.logger.info "board moves: #{moves.length}"
 return moves
end
   

   
end
