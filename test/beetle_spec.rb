require '../test/test_utils'
require 'set'


#FIXME: work in progress
describe Hive::Beetle do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	  Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = @board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider = @board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
      @black_ant = 		@board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
      @white_beetle = @board_state.get_piece_by_id(Hive::Piece::WHITE_BEETLE1)  
   end 

    it 'should have the right available_board_moves TEST1' do
        @board_state.make_move( @white_player ,   Hive::Move.new_with_cords( @white_queen ,5,4,0)) 
        @board_state.make_move( @black_player ,   Hive::Move.new_with_cords( @black_spider ,6,4,0))
        @board_state.make_move( @white_player ,   Hive::Move.new_with_cords( @white_spider ,6,5,0))
        @board_state.make_move( @black_player ,   Hive::Move.new_with_cords( @black_ant ,4,5,0))
        @board_state.make_move( @white_player ,   Hive::Move.new_with_cords( @white_beetle ,5,5,0))

        @possible_moves = [ 	Hive::Move.new_with_cords( @white_beetle,5,4,1), 
                              Hive::Move.new_with_cords( @white_beetle,6,4,1),
                              Hive::Move.new_with_cords( @white_beetle,6,5,1),
                              Hive::Move.new_with_cords( @white_beetle,4,5,1),
                              Hive::Move.new_with_cords( @white_beetle,5,6,0),
                              Hive::Move.new_with_cords( @white_beetle,6,6,0),
                            ].to_set
      
      moves = Hive::Beetle.available_board_moves( @white_beetle ).to_set
      TestUtils.match_move_sets( moves,  @possible_moves )
    end
  
end
