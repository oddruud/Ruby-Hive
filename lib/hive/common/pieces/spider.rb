require 'piece'
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

#ARG!!!!
def self.available_board_moves( spider )  
  moves = []
  spider.touch do
    slots = Set.new()  
    Hive::Spider.step(spider, spider, Set.new(), slots)
    slots.each {|s| moves << Hive::Move.new(spider , s)}
  end
  return moves
end

def self.step( spider, current_slot, slot_history, result_slots)
   current_slot.for_each_adjacent_slot do |next_slot, side|  
     history_branch = slot_history.clone
     unless history_branch.include?( next_slot ) || spider.board_position == next_slot.board_position #|| current_slot.gap_between?( next_slot ) #TODO: gap between is temporary 
      history_branch << next_slot
      if history_branch.size < 3
        step(spider, next_slot, history_branch, result_slots)
      elsif history_branch.size == 3 
        result_slots << next_slot
      end    
    end
  end
end  

  
end
