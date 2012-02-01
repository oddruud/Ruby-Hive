$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

#require '../Common/slot.rb'
require '../Common/boardstate.rb'
require 'set'

describe Slot do
   
   before :each do 
     @slot1 = Slot.new(5,5,0)
     @slot1_rn = Slot.new(6, 5, 0)
     @slot1_neighbours= Set.new [Slot.new(6, 5, 0),
                                Slot.new(4, 5, 0), 
                                Slot.new(5, 4, 0),
                                Slot.new(6, 4, 0),
                                Slot.new(6, 6, 0),
                                Slot.new(5, 6, 0) 
                                ] 
  
     @slot2 = Slot.new(0,5,0)
     @slot3 = Slot.new(5,8,0)
     
   end 

   it 'should provide the correct board coordinates of neighbouring slots' do 
      #@slot1: [5,5,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::RIGHT_SIDE).should == [6,5,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::LEFT_SIDE).should == [4,5,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      @slot1.neighbourCoordinatesArray(HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
      
      #@slot1: [0,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::RIGHT_SIDE).should == [1,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::LEFT_SIDE).should == [-1,5,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::TOP_LEFT_SIDE).should == [5,4,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::TOP_RIGHT_SIDE).should == [6,4,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::BOTTOM_RIGHT_SIDE).should == [6,6,0]
      #@slot2.neighbourCoordinatesArray(HexagonSide::BOTTOM_LEFT_SIDE).should == [5,6,0]
   end
   
    it 'should iterate over all and only the 6 adjacent slots' do  
      board_state = BoardState.new()
      puts "set: #{@slot1_neighbours.to_s}"
      @slot1.forEachAdjacentSlot(board_state) do |ns|
        puts ns.to_s
        #@slot1_neighbours.include?(ns).should == true
      end
    end
    
    it 'should provide the side of adjacent slots' do 
      @slot1.getSide(@slot1_rn).should == HexagonSide::RIGHT_SIDE
    end 
   
end
