require 'Insects/piece'
class Hive::LadyBug < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
 
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used?
  moves += Hive::LadyBug.available_board_moves(self) if used? and movable?
 return moves
end 

def self.available_board_moves(ladybug)
  moves = Array.new()
  #ladybug.touch do 
  #  moves
  #end
  return moves
end

def trapped?
  return false
end
  
end