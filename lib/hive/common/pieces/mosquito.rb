require 'piece'
class Hive::Mosquito < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used? 
  moves += Hive::Mosquito.available_board_moves(self)  if used?
 return moves
end

def self.available_board_moves(mosquito)  
  moves = Array.new()
    mosquito.for_each_adjacent_piece do |neighbour|
        moves += neighbour.class.available_board_moves( mosquito ) unless neighbour.kind_of? Hive::Mosquito         
    end
 return moves
end
   

   
end
