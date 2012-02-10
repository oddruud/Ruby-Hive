require 'Insects/piece'
#require 'MoveValidators/SpiderMoveValidator'

class Hive::Spider < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
   #@validator = SpiderMoveValidator  
end
  
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used?
  moves += Hive::Spider.available_board_moves(self) if used? and movable?
 return moves
end

def self.available_board_moves( spider )
  moves = []
  spider.touch do
    self.traverse_board(spider, spider,nil,0, moves)
  end 
  spider.logger.info "board moves: #{moves.length}"
  return moves
end

 #TODO
def self.traverse_board( spider, current_slot, prev_slot, step_count, result_moves ) #TODO only move one way, check prevslot
   current_slot.for_each_adjacent_slot do |neighbour_slot|
     unless prev_slot == neighbour_slot     
        if step_count == 0
          puts "neighbour slot: #{neighbour_slot}" 
          result_moves << Hive::Move.new(spider , neighbour_slot)  
        else
          step_count += 1
          traverse_board(spider, neighbour_slot, current_slot, step_count, result_moves)
        end
    end
  end
end  

  
end
