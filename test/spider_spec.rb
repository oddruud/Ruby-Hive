
require 'rubygems'
require 'hive'
require 'set'

#FIXME: work in progress
describe Hive::Spider do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = 	@board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
      @black_ant = 		@board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
     
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_queen ,5,4,0)) 
      @board_state.make_move( @black_player, Hive::Move.new_with_cords( @black_spider ,6,4,0))
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_spider ,6,5,0))
      @board_state.make_move( @black_player, Hive::Move.new_with_cords( @black_ant ,4,5,0))
      
      @possible_ant_moves = [ 	Hive::Move.new_with_cords(@black_ant,4,4,0), 
                            	Hive::Move.new_with_cords(@black_ant,4,3,0),
                            	Hive::Move.new_with_cords(@black_ant,5,3,0),
                            	Hive::Move.new_with_cords(@black_ant,6,3,0),
                            	Hive::Move.new_with_cords(@black_ant,7,4,0),
                            	Hive::Move.new_with_cords(@black_ant,7,5,0),
                            	Hive::Move.new_with_cords(@black_ant,7,6,0),
                            	Hive::Move.new_with_cords(@black_ant,6,6,0),
                            	Hive::Move.new_with_cords(@black_ant,5,5,0)
                          ].to_set 
   end 

    it 'should have the right available_board_moves' do
      moves = Hive::Ant.available_board_moves( @black_ant )
      moves = moves.to_set 
      @possible_ant_moves.length.should == moves.length
      @possible_ant_moves.each do |possible|
 	  	match = [possible,false]	    
      	moves.each { |available| match = [possible, true] if available.dest_slot == possible.dest_slot }
      	match.should == [possible, true]
      end
    end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@board_state.get_piece_by_id(100)}
   #end  
end
