require 'piece'

class Hive::QueenBee < Hive::Piece

def initialize(board_state, id)
  super(board_state, id) 
  raise "id of qieen not correct" unless Hive::Piece.valid_id?(id) 
end
  
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used?
  moves += Hive::QueenBee.available_board_moves( self ) if used? and movable?
 return moves
end

def self.available_board_moves(queenbee)
  moves = Array.new()
  queenbee.touch do
    queenbee.for_each_adjacent_slot do |slot|    
      moves << Hive::Move.new(queenbee , slot)
    end  
 end
 return moves
end

    
end
