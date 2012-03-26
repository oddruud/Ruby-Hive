require '../test/test_utils'
require 'set'

describe Hive::Piece do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	  Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = 	  @board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = 	@board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
      @black_ant = 		  @board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1)  
   end 

   #TODO take a look at piece.used in respect to checking validity of boardstate and touch event.
    it 'be movable when valid moves are available' do
        @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_queen ,5,4,0)) 
        @board_state.make_move( @black_player , Hive::Move.new_with_cords( @black_spider ,6,4,0))
        @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_spider ,6,5,0))
        @board_state.make_move( @black_player , Hive::Move.new_with_cords( @black_ant ,4,5,0))
        
        #queen_move_valid = true
        #puts "move attempt for #{@white_queen}"
        #@white_queen.touch { queen_move_valid = @board_state.valid? }
        #queen_move_valid.should == false
        #       
        #         ant_move_valid = false
        #         puts "move attempt for #{@black_ant}"
        #         @black_ant.touch { ant_move_valid = @board_state.valid? }
        #         ant_move_valid.should == true
        #         
        @white_queen.movable?.should == false
        @black_spider.movable? == false
        @white_spider.movable?.should == true 
        @black_ant.movable?.should == true
    end
  
end
