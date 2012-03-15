
require 'rubygems'
require '../lib/hive' #replace with hive on publish
require 'set'


#FIXME: work in progress
describe Hive::Spider do
   
   before :each do 
      Logger.set_level(Logger::INFO)
      
      @board_state = 	  Hive::BoardState.new("test_board")
      @black_player = 	Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = 	Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_beetle = 	@board_state.get_piece_by_id(Hive::Piece::WHITE_BEETLE1) 
      @black_spider = @board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider2 = @board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER2) 
      @black_ant = 		@board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
      @white_spider = @board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
     
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_beetle ,5,4,0)) 
      @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_spider ,6,4,0))
      @board_state.make_move( @white_player , Hive::Move.new_with_cords( @white_spider2 ,6,5,0))
      @board_state.make_move( @black_player,  Hive::Move.new_with_cords( @black_ant ,4,5,0))
      @board_state.make_move( @white_player,  Hive::Move.new_with_cords( @white_spider ,5,5,0))
      
      @possible_moves = [ 	Hive::Move.new_with_cords( @white_spider,3,5,0), 
                            Hive::Move.new_with_cords( @white_spider,7,5,0)
                          ].to_set 
   end 

    it 'should have the right available_board_moves' do
      moves = Hive::Spider.available_board_moves( @white_spider )
      moves = moves.to_set 

      puts "#{moves.length} moves found----"
      moves.each {|m| puts m}
      puts "#{@possible_moves.length} expected moves----"
      @possible_moves.each {|m| puts m}
      puts "----"
      
      # @possible_moves.length.should == moves.length
      #       @possible_moves.each do |possible|
      #         match = [possible,false]      
      #         moves.each { |available| match = [possible, true] if available.dest_slot == possible.dest_slot }
      #         match.should == [possible, true]
      #       end
    end
    
    it 'should see the gap' do
      @board_state.get_slot_at(5,6,0).gap_between?( @board_state.get_slot_at(6,6,0) ).should == true 
    end

end
