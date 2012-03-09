require 'rubygems'
require '../lib/hive' #replace with hive on publish
require 'set'


#FIXME: work in progress
describe Hive::BoardState do
   
   before :each do 
     @black_player = Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
     @white_player = Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
     
     @board_state= Hive::BoardState.new("TEST BOARD")
     
     #play some moves: 
     @white_queen = @board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
     @black_queen = @board_state.get_piece_by_id(Hive::Piece::BLACK_QUEEN_BEE) 
     
     @board_state.make_move(@white_player, Hive::Move.new_with_cords(@white_queen,5,5,0)) 
     @board_state.make_move(@black_player, Hive::Move.new_with_cords(@black_queen,6,5,0))  
   end 
   
   it 'should provide a slot when right x,y,z provided' do 
      @board_state.get_slot_at(5,6,0).should == Hive::Slot.new(@board_state,5,6,0,-1)
   end
    
  it 'should provide a piece when right x,y,z provided' do 
     @board_state.get_slot_at(5,5,0).should == Hive::Piece.new(@board_state, Hive::Piece::WHITE_QUEEN_BEE) {|p| p.set_board_position(5, 5, 0)}
     @board_state.get_piece_at(5,5,0).should == Hive::Piece.new(@board_state, Hive::Piece::WHITE_QUEEN_BEE) {|p| p.set_board_position(5, 5, 0)}
  end
  
  it 'should provide deep cloning, no references to pieces on board' do
    clone = @board_state.clone
    clone.should_not == @board_state
  end
  
  it 'should only contain unique IDs after moving pieces, thus clean moving' do 
     @board_state.make_move(@white_player, Hive::Move.new_with_cords(@white_queen ,1,5,0)) 
     @board_state.make_move(@black_player, Hive::Move.new_with_cords(@black_queen, 2,5,0))
     @board_state.make_move(@white_player, Hive::Move.new_with_cords(@white_queen ,7,5,0))
    
     id_bag = Set.new()  
     
     @board_state.each_board_position  do |x,y,z,value|
       id_bag.include?(value).should == false
       id_bag.add(value) if value > Hive::Slot::UNCONNECTED 
     end
  end
  
  it 'should positively identify bottlenecks' do 
    black_ant = @board_state.get_piece_by_id(Hive::Piece::BLACK_ANT2) 
    white_ant = @board_state.get_piece_by_id(Hive::Piece::WHITE_ANT1) 
     
   @board_state.make_move(@white_player, Hive::Move.new_with_cords(white_ant,6,1,0)) 
   @board_state.make_move(@black_player, Hive::Move.new_with_cords(black_ant,6,3,0))
       
   slot1 =  @board_state.get_slot_at(6,2,0)
   slot2 = @board_state.get_slot_at(7,2,0)
   @board_state.bottle_neck_between_slots(slot1, slot2).should == true
   
   @board_state.make_move(@white_player, Hive::Move.new_with_cords(white_ant,2,6,0)) 
   @board_state.make_move(@black_player, Hive::Move.new_with_cords(black_ant,3,7,0))
    
   slot1 = @board_state.get_slot_at(2,7,0)
   slot2 = @board_state.get_slot_at(3,6,0)
   @board_state.bottle_neck_between_slots(slot1, slot2).should == true
   
   
  end
  
  it 'should not positively identify non-bottlenecks' do 
   white_ant = @board_state.get_piece_by_id(Hive::Piece::WHITE_ANT1) 
   @board_state.make_move(@white_player, Hive::Move.new_with_cords(white_ant,6,1,0)) 
       
   slot1 =  @board_state.get_slot_at(6,2,0)
   slot2 = @board_state.get_slot_at(7,2,0)
   @board_state.bottle_neck_between_slots(slot1, slot2).should == false
  end
  
  #TEST FOR: remove_piece_from_board(piece)
  it 'should heal the state of surrounding slots after removing a piece' do
    ant1 = @board_state.get_piece_by_id(Hive::Piece::WHITE_ANT1)
    @board_state.make_move(@white_player, Hive::Move.new_with_cords(ant1, 5,6,0)) 
    
    #UNCONNECTED = -1
    #EMPTY_SLOT_WHITE = -2
    #EMPTY_SLOT_BLACK = -3
    #EMPTY_SLOT_MIXED = -4
    
    #before removal:
    ant1.neighbour(Hive::HexagonSide::RIGHT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_MIXED 
    ant1.neighbour(Hive::HexagonSide::LEFT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(Hive::HexagonSide::TOP_LEFT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(Hive::HexagonSide::TOP_RIGHT_SIDE).value().should == Hive::Piece::WHITE_QUEEN_BEE 
    ant1.neighbour(Hive::HexagonSide::BOTTOM_RIGHT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_WHITE
    ant1.neighbour(Hive::HexagonSide::BOTTOM_LEFT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_WHITE
    
    @board_state.remove_piece_from_board(ant1)
    
    #after removal 
    slot =  @board_state.get_slot_at(ant1.x,ant1.y,ant1.z) 

    slot.neighbour(Hive::HexagonSide::RIGHT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_MIXED 
    #slot.neighbour(Hive::HexagonSide::LEFT_SIDE).value().should == Hive::Slot::UNCONNECTED
    slot.neighbour(Hive::HexagonSide::TOP_LEFT_SIDE).value().should == Hive::Slot::EMPTY_SLOT_WHITE
    slot.neighbour(Hive::HexagonSide::TOP_RIGHT_SIDE).value().should == Hive::Piece::WHITE_QUEEN_BEE
    #slot.neighbour(Hive::HexagonSide::BOTTOM_RIGHT_SIDE).value().should == Hive::Slot::UNCONNECTED
    #slot.neighbour(Hive::HexagonSide::BOTTOM_LEFT_SIDE).value().should == Hive::Slot::UNCONNECTED
    slot.value().should == Hive::Slot::EMPTY_SLOT_WHITE
  end
  
  it 'should be able to tell whether a piece configuration is valid or invalid' do
    
    @board_state.valid?.should == true 
    
    @black_ant1 = @board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
    @board_state.make_move(@black_player, Hive::Move.new_with_cords(@black_ant1,5,9,0))
    @board_state.valid?.should == false 
       
    @board_state.make_move(@black_player, Hive::Move.new_with_cords(@black_ant1,6,6,0))
    @board_state.valid?.should == true
    
  end
  
  it 'should change the states of surrounding pieces for a touched piece, and change them back after the touch' do
  	
    #@white_queen is at 5,5,0
    #@black_queen is at 6,5,0 
    
    @board_state.at(5,4,0).should == Hive::Slot::EMPTY_SLOT_WHITE
  	@board_state.at(4,5,0).should == Hive::Slot::EMPTY_SLOT_WHITE
  	@board_state.at(5,6,0).should == Hive::Slot::EMPTY_SLOT_WHITE
    
  	@white_queen.touch do
  		@board_state.at(5,4,0).should == Hive::Slot::UNCONNECTED
  		@board_state.at(4,5,0).should == Hive::Slot::UNCONNECTED
  		@board_state.at(5,6,0).should == Hive::Slot::UNCONNECTED
  	end
  	
  	@board_state.at(5,4,0).should == Hive::Slot::EMPTY_SLOT_WHITE
  	@board_state.at(4,5,0).should == Hive::Slot::EMPTY_SLOT_WHITE
  	@board_state.at(5,6,0).should == Hive::Slot::EMPTY_SLOT_WHITE
  	
  end
  
  #TODO
  it 'should be able to tell whether a piece can be moved or not (locked and trapped algorithms)' do
  	1.should == 1
  end 
end
