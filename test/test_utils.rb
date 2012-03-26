require 'rubygems'
require '../lib/hive' #replace with hive on publish

class TestUtils
def self.match_move_sets(are_moves, shouldbe_moves, feedback = true)
   
   are_moves.should_not == nil
   shouldbe_moves.should_not == nil
   
   if feedback
    puts "#{are_moves.length} moves found----"
    are_moves.each {|m| puts m}
    puts "#{shouldbe_moves.length} expected moves----"
    shouldbe_moves.each {|m| puts m}
    puts "----"
   end
   
   shouldbe_moves.length.should == are_moves.length
   shouldbe_moves.each do |mv|
  	  match = [mv,false]	    
      are_moves.each { |available| match = [mv, true] if available.dest_slot == mv.dest_slot }
      match.should == [mv, true]
    end
end
end