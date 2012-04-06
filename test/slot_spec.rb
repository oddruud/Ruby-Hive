require 'rubygems'
require '../test/test_utils'
require 'set'


#FIXME: work in progress
describe Hive::Slot do
   
   before :each do 
   	 @board_state = Hive::BoardState.new()
     @slot1 = Hive::Slot.new( @board_state , 5,5,0)
     @slot2 = Hive::Slot.new( @board_state , 0,5,0)
     @slot3 = Hive::Slot.new( @board_state , 5,8,0)
     
     @slot1_neighbours= Set.new [ Hive::Slot.new( @board_state , 6, 5, 0),
                                  Hive::Slot.new( @board_state , 4, 5, 0), 
                                  Hive::Slot.new( @board_state , 5, 4, 0),
                                  Hive::Slot.new( @board_state , 6, 4, 0),
                                  Hive::Slot.new( @board_state , 6, 6, 0),
                                  Hive::Slot.new( @board_state , 5, 6, 0) 
                                ] 
                                
   end 

   it 'should provide the correct board coordinates of neighbouring slots' do 
      #@slot1: [5,5,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::RIGHT_SIDE).should == [6,5,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::LEFT_SIDE).should == [4,5,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      @slot1.neighbour_coordinates_array(Hive::HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
      
      #@slot2: [0,5,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::RIGHT_SIDE).should == [1,5,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::LEFT_SIDE).should == [-1,5,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      #@slot2.neighbour_coordinates_array(HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
   end
   
   it '(get_side) should be able to translate an absolute neighbour address to a relative side address' do
      @slot1.for_each_adjacent_slot do |slot, side|
        @slot1.get_side(slot).should == side
      end
      
      slot_R  = Hive::Slot.new( @board_state , 6, 5, 0)
      slot_L  = Hive::Slot.new( @board_state , 4, 5, 0) 
      slot_TL = Hive::Slot.new( @board_state , 5, 4, 0)
      slot_TR = Hive::Slot.new( @board_state , 6, 4, 0) 
      slot_BR = Hive::Slot.new( @board_state , 6, 6, 0) 
      slot_BL = Hive::Slot.new( @board_state , 5, 6, 0) 
      
      @slot1.get_side(slot_R).should  == Hive::HexagonSide::RIGHT_SIDE
      @slot1.get_side(slot_L).should  == Hive::HexagonSide::LEFT_SIDE
      @slot1.get_side(slot_TL).should == Hive::HexagonSide::TOP_LEFT_SIDE
      @slot1.get_side(slot_TR).should == Hive::HexagonSide::TOP_RIGHT_SIDE
      @slot1.get_side(slot_BR).should == Hive::HexagonSide::BOTTOM_RIGHT_SIDE
      @slot1.get_side(slot_BL).should == Hive::HexagonSide::BOTTOM_LEFT_SIDE
      
   end
   
    it 'should iterate over all and only the 6 adjacent slots' do  
      @slot1.for_each_adjacent_slot do |ns|
        @slot1_neighbours.include?(ns).should == true
      end
    end
   
end
