require 'Insects/piece'
class Beetle < Piece

def initialize(board_state, id)
  super(board_state, id)  
end
 
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  moves += Beetle.availableBoardMoves(self) if used? and movable?
 return moves
end 
 
#TODO fix! what if beetle is ontop? handle beetle stacking
def self.availableBoardMoves( beetle )
  moves = Array.new()
  board_state = beetle.getBoard
   beetle.forEachNeighbouringSlotOrPiece do |slot|
      numPieces = board_state.getNumPiecesAt(slot.x, slot.y)          
      moves << Move.fromCords(beetle.id, slot.x, slot.y, numPieces )
   end  
 return moves
end

def trapped?
end
  
end