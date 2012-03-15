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
    self.step(spider, spider, Set.new(), slots)
    puts "#{slots.length} slots found"
    slots.each {|s| moves << Hive::Move.new(spider , s)}
  end
  spider.logger.info "board moves: #{moves.length}"
  return moves
end

 #TODO GAP BETWEEN MUST BE IMPLEMENTED FOR ALL SLOTS: the neighbour iteration should not return slots with a gap, since they are not neighbours
def self.step( spider, current_slot, slot_history, result_slots) #TODO only move one way, check prevslot
   current_slot.for_each_adjacent_slot do |next_slot|  
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
