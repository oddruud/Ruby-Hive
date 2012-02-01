$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'
require '../Common/player.rb'
require 'set'

describe BoardState do
   
   before :each do 
     @black_player = Player.new('unittest player BLACK', PieceColor::BLACK)
     @white_player = Player.new('unittest player WHITE', PieceColor::WHITE)
     
     @board_state= BoardState.new("TEST BOARD")
     
     #play some moves: 
     @white_queen = @board_state.getPieceById(Piece::WHITE_QUEEN_BEE) 
     @black_queen = @board_state.getPieceById(Piece::BLACK_QUEEN_BEE) 
     
     @board_state.make_move(@white_player, Move.fromCords(@white_queen,5,5,0)) 
     @board_state.make_move(@black_player, Move.fromCords(@black_queen,6,5,0))  
   end 
   
   it 'should provide a slot when right x,y,z provided' do 
      @board_state.getSlotAt(5,6,0).should == Slot.new(@board_state,5,6,0,-1)
   end
    
  it 'should provide a piece when right x,y,z provided' do 
     @board_state.getSlotAt(5,5,0).should == Piece.new(@board_state, Piece::WHITE_QUEEN_BEE) {|p| p.setBoardPosition(5, 5, 0)}
     @board_state.getPieceAt(5,5,0).should == Piece.new(@board_state, Piece::WHITE_QUEEN_BEE) {|p| p.setBoardPosition(5, 5, 0)}
  end
  
  it 'should provide deep cloning, no references to pieces on board' do
    clone = @board_state.clone
    clone.should_not == @board_state
  end
  
  it 'should only contain unique IDs after moving pieces, thus clean moving' do 
     @board_state.make_move(@white_player, Move.fromCords(@white_queen ,1,5,0)) 
     @board_state.make_move(@black_player, Move.fromCords(@black_queen,2,5,0))
     @board_state.make_move(@white_player, Move.fromCords(@white_queen ,7,5,0))
    
     id_bag = Set.new()  
     
     @board_state.eachBoardPosition  do |x,y,z,value|
       id_bag.include?(value).should == false
       id_bag.add(value) if value > Slot::UNCONNECTED 
     end
  end
  
  it 'should positively identify bottlenecks' do 
    black_ant = @board_state.getPieceById(Piece::BLACK_ANT2) 
    white_ant = @board_state.getPieceById(Piece::WHITE_ANT1) 
     
   @board_state.make_move(@white_player, Move.fromCords(white_ant,6,1,0)) 
   @board_state.make_move(@black_player, Move.fromCords(black_ant,6,3,0))
       
   slot1 =  @board_state.getSlotAt(6,2,0)
   slot2 = @board_state.getSlotAt(7,2,0)
   @board_state.bottleNeckBetweenSlots(slot1, slot2).should == true
   
   @board_state.make_move(@white_player, Move.fromCords(white_ant,2,6,0)) 
   @board_state.make_move(@black_player, Move.fromCords(black_ant,3,7,0))
    
   slot1 = @board_state.getSlotAt(2,7,0)
   slot2 = @board_state.getSlotAt(3,6,0)
   @board_state.bottleNeckBetweenSlots(slot1, slot2).should == true
   
   
  end
  
  it 'should not positively identify non-bottlenecks' do 
   white_ant = @board_state.getPieceById(Piece::WHITE_ANT1) 
   @board_state.make_move(@white_player, Move.fromCords(white_ant,6,1,0)) 
       
   slot1 =  @board_state.getSlotAt(6,2,0)
   slot2 = @board_state.getSlotAt(7,2,0)
   @board_state.bottleNeckBetweenSlots(slot1, slot2).should == false
  end
  
  #TEST FOR: removePieceFromBoard(piece)
  it 'should heal the state of surrounding slots after removing a piece' do
    ant1 = @board_state.getPieceById(Piece::WHITE_ANT1)
    @board_state.make_move(@white_player, Move.fromCords(ant1,5,6,0)) 
    
    #UNCONNECTED = -1
    #EMPTY_SLOT_WHITE = -2
    #EMPTY_SLOT_BLACK = -3
    #EMPTY_SLOT_MIXED = -4
    
    #before removal:
    ant1.neighbour(HexagonSide::RIGHT_SIDE).value().should == Slot::EMPTY_SLOT_MIXED 
    ant1.neighbour(HexagonSide::LEFT_SIDE).value().should == Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(HexagonSide::TOP_LEFT_SIDE).value().should == Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(HexagonSide::TOP_RIGHT_SIDE).value().should == Piece::WHITE_QUEEN_BEE 
    ant1.neighbour(HexagonSide::BOTTOM_RIGHT_SIDE).value().should == Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(HexagonSide::BOTTOM_LEFT_SIDE).value().should == Slot::EMPTY_SLOT_WHITE
    
    @board_state.removePieceFromBoard(ant1)
    
    #after removal 
    slot =  @board_state.getSlotAt(ant1.x,ant1.y,ant1.z) 

    slot.neighbour(HexagonSide::RIGHT_SIDE).value().should == Slot::EMPTY_SLOT_MIXED 
    slot.neighbour(HexagonSide::LEFT_SIDE).value().should == Slot::UNCONNECTED
    slot.neighbour(HexagonSide::TOP_LEFT_SIDE).value().should == Slot::EMPTY_SLOT_WHITE
    slot.neighbour(HexagonSide::TOP_RIGHT_SIDE).value().should == Piece::WHITE_QUEEN_BEE
    slot.neighbour(HexagonSide::BOTTOM_RIGHT_SIDE).value().should == Slot::UNCONNECTED
    slot.neighbour(HexagonSide::BOTTOM_LEFT_SIDE).value().should == Slot::UNCONNECTED
    slot.value().should == Slot::EMPTY_SLOT_WHITE
  end
  
  it 'should be able to tell whether a piece configuration is valid or invalid' do
    
    @board_state.valid?.should == true 
    
    @black_ant1 = @board_state.getPieceById(Piece::BLACK_ANT1) 
    @board_state.make_move(@black_player, Move.fromCords(@black_ant1,5,9,0))
    @board_state.valid?.should == false 
       
    @board_state.make_move(@black_player, Move.fromCords(@black_ant1,6,6,0))
    @board_state.valid?.should == true
    
  end
  
end
