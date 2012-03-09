
require 'rubygems'
require '../lib/hive' #replace with hive on publish
require 'set'

describe Hive::Mosquito do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	  Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = @board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider = @board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
      @black_ant = 		@board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
      @white_mosquito = @board_state.get_piece_by_id(Hive::Piece::WHITE_MOSQUITO) 
     
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_queen ,5,4,0)) 
      @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_spider ,6,4,0))
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_spider ,6,5,0))
      @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_ant ,4,5,0))
      @board_state.make_move( @white_player,  Hive::Move.new_with_cords( @white_mosquito ,5,5,0))
      
      @possible_moves = [ 	Hive::Move.new_with_cords( @white_mosquito, 3 , 5 , 0), 
                            Hive::Move.new_with_cords( @white_mosquito, 4 , 3 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 6 , 3 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 7 , 5 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 5 , 4 , 1), 
                            Hive::Move.new_with_cords( @white_mosquito, 6 , 4 , 1),
                            Hive::Move.new_with_cords( @white_mosquito, 6 , 5 , 1),
                            Hive::Move.new_with_cords( @white_mosquito, 4 , 5 , 1),
                            Hive::Move.new_with_cords( @white_mosquito, 5 , 6 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 6 , 6 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 7 , 6 , 0),
                            Hive::Move.new_with_cords( @white_mosquito, 4 , 6 , 0), 
                            Hive::Move.new_with_cords( @white_mosquito, 4 , 4 , 0),   
                            Hive::Move.new_with_cords( @white_mosquito, 5 , 3 , 0),  
                            Hive::Move.new_with_cords( @white_mosquito, 7 , 4 , 0)  
                          ].to_set 
   end 

    it 'should have the right available_board_moves' do
      moves = Hive::Mosquito.available_board_moves( @white_mosquito )
      moves = moves.to_set 

      moves.each {|m| puts m}
      puts "----"
      @possible_moves.each {|m| puts m}
      puts "----"

      @possible_moves.length.should == moves.length
      @possible_moves.each do |possible|
 	  	  match = [possible,false]	    
        moves.each { |available| match = [possible, true] if available.dest_slot == possible.dest_slot }
        match.should == [possible, true]
      end
    end
  
end
