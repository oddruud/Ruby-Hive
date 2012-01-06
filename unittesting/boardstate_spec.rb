$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'
require 'set'

describe BoardState do
   
   before :each do 
     @board_state= BoardState.new("test_board")
     #play some moves: 
     @board_state.makeMove(Move.fromCords(Piece::WHITE_QUEEN_BEE,5,5,0)) 
     @board_state.makeMove(Move.fromCords(Piece::BLACK_QUEEN_BEE,7,5,0))  
   end 
   
   it 'should provide a slot when right x,y,z provided' do 
      @board_state.getSlotAt(5,6,0).should == Slot.new(5,6,0)
   end
    
  it 'should provide a piece when right x,y,z provided' do 
     @board_state.getSlotAt(5,5,0).should == Piece.new(5, 5, 0, Piece::WHITE_QUEEN_BEE)
     @board_state.getPieceAt(5,5,0).should == Piece.new(5, 5, 0, Piece::WHITE_QUEEN_BEE)
  end
  
  it 'should provide deep cloning, no references to pieces on board' do
    clone = @board_state.clone
    clone.should_not == @board_state
  end
  
  it 'should only contain unique IDs after moving pieces, thus clean moving' do 
     @board_state.makeMove(Move.fromCords(Piece::WHITE_QUEEN_BEE,1,5,0)) 
     @board_state.makeMove(Move.fromCords(Piece::BLACK_QUEEN_BEE,2,5,0))
     @board_state.makeMove(Move.fromCords(Piece::WHITE_QUEEN_BEE,7,5,0))
    
     id_bag = Set.new()  
     
     @board_state.eachBoardPosition  do |x,y,z,value|
       id_bag.include?(value).should == false
       id_bag.add(value) if value > Slot::UNCONNECTED 
     end
  end
  
  it 'should positively identify bottlenecks' do 
   @board_state.makeMove(Move.fromCords(Piece::WHITE_ANT1,6,1,0)) 
   @board_state.makeMove(Move.fromCords(Piece::BLACK_ANT2,6,3,0))
       
   slot1 =  @board_state.getSlotAt(6,2,0)
   slot2 = @board_state.getSlotAt(7,2,0)
   @board_state.bottleNeckBetweenSlots(slot1, slot2).should == true
  end
  
  it 'should not positively identify non-bottlenecks' do 
   @board_state.makeMove(Move.fromCords(Piece::WHITE_ANT1,6,1,0)) 
       
   slot1 =  @board_state.getSlotAt(6,2,0)
   slot2 = @board_state.getSlotAt(7,2,0)
   @board_state.bottleNeckBetweenSlots(slot1, slot2).should == false
  end
  
end
