$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../lib/' ) )

require 'hive.rb'
require 'set'

describe Hive::Slot do
   
   before :each do 
   	 @board_state = Hive::BoardState.new()
     @slot1 = Hive::Slot.new(5,5,0)
     @slot1_rn = Hive::Slot.new(6, 5, 0)
     @slot1_neighbours= Set.new [Hive::Slot.new( @board_state , 6, 5, 0),
                                Hive::Slot.new( @board_state , 4, 5, 0), 
                                Hive::Slot.new( @board_state , 5, 4, 0),
                                Hive::Slot.new( @board_state , 6, 4, 0),
                                Hive::Slot.new( @board_state , 6, 6, 0),
                                Hive::Slot.new( @board_state , 5, 6, 0) 
                                ] 
  
     @slot2 = Hive::Slot.new( @board_state , 0,5,0)
     @slot3 = Hive::Slot.new( @board_state , 5,8,0)
     
   end 

   it 'should provide the correct board coordinates of neighbouring slots' do 
      #@slot1: [5,5,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::RIGHT_SIDE).should == [6,5,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::LEFT_SIDE).should == [4,5,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      @slot1.neighbourCoordinatesArray(Hive::HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
      
      #@slot1: [0,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::RIGHT_SIDE).should == [1,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::LEFT_SIDE).should == [-1,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
   end
   
    it 'should iterate over all and only the 6 adjacent slots' do  
      
      puts "set: #{@slot1_neighbours.to_s}"
      @slot1.forEachAdjacentSlot do |ns|
        @slot1_neighbours.include?(ns).should == true
      end
    end
    
    it 'should provide the side of adjacent slots' do 
      @slot1.getSide(@slot1_rn).should == Hive::HexagonSide::RIGHT_SIDE
    end 
   
end
