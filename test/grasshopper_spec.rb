
require 'rubygems'
require '../test/test_utils'
require 'set'

describe Hive::GrassHopper do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	  Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = @board_state.get_piece_by_id(Hive::Piece::BLACK_GRASSHOPPER1) 
      @white_spider = @board_state.get_piece_by_id(Hive::Piece::WHITE_BEETLE1) 
      @black_ant = 		@board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
      @white_grasshopper = @board_state.get_piece_by_id(Hive::Piece::WHITE_GRASSHOPPER1) 
   end 

    it 'should have the right available_board_moves TEST1' do
        @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_queen ,5,4,0)) 
        @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_spider ,6,4,0))
        @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_spider ,6,5,0))
        @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_ant ,4,5,0))
        @board_state.make_move( @white_player,  Hive::Move.new_with_cords( @white_grasshopper ,5,5,0))

        @possible_moves = [ 	Hive::Move.new_with_cords( @white_grasshopper, 3, 5, 0), 
                              Hive::Move.new_with_cords( @white_grasshopper, 4, 3, 0),
                              Hive::Move.new_with_cords( @white_grasshopper, 6, 3, 0),
                              Hive::Move.new_with_cords( @white_grasshopper, 7, 5, 0)
                          ].to_set
      
      moves = Hive::GrassHopper.available_board_moves( @white_grasshopper ).to_set
      TestUtils.match_move_sets( moves,  @possible_moves )
    end
  
end
