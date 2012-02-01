$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../lib/' ) )

require 'hive.rb'
require 'set'

describe Hive::Ant do
   
   before :each do 
     LoggerCreator.setLevel(Logger::INFO)
      @board_state = Hive::BoardState.new("test_board")
      @black_player = Hive::Player.new('unittest player BLACK', Hive::PieceColor::BLACK)
      @white_player = Hive::Player.new('unittest player WHITE', Hive::PieceColor::WHITE)
      
      @white_queen = @board_state.get_piece_by_id(Hive::Piece::WHITE_QUEEN_BEE) 
      @black_spider = @board_state.get_piece_by_id(Hive::Piece::BLACK_SPIDER1) 
      @white_spider = @board_state.get_piece_by_id(Hive::Piece::WHITE_SPIDER1) 
      @black_ant = @board_state.get_piece_by_id(Hive::Piece::BLACK_ANT1) 
     
       #ONTOP_SIDE = 0
  	   #UNDER_SIDE = 1 
  	   #RIGHT_SIDE = 2
       #BOTTOM_RIGHT_SIDE = 3
       #BOTTOM_LEFT_SIDE = 4
       #LEFT_SIDE = 5
       #TOP_LEFT_SIDE = 6
       #TOP_RIGHT_SIDE = 7
       
      #TODO fix coordinates 
      @board_state.make_move(@white_player , Hive::Move.fromCords(@white_queen ,5,5,0)) 
      @board_state.make_move(@black_player, Hive::Move.fromCords(@black_spider ,5,5,0))
      @board_state.make_move(@white_player , Hive::Move.fromCords( @white_spider ,0,0,0))
      @board_state.make_move(@black_player, Hive::Move.fromCords( @black_ant ,0,0,0))
      
      @possible_ant_moves = [ 	Hive::Move.fromCords(@black_ant,0,0,0), 
                            	Hive::Move.fromCords(@black_ant,0,0,0)
                          ].to_set 
   end 

    it 'should have the right availableBoardMoves' do
      moves = @black_ant.availableBoardMoves
      moves = moves.to_set 
      
      puts "board situation:\n #{@board_state.to_s}"
      
      puts "should have:"
       @possible_ant_moves.each{|move| puts move.to_s}  
      puts "determined:"
       moves.each do |move| 
         board_next = @board_state.nextState(move)
         puts move.to_s + "\n"
         puts "next: " + board_next.to_s
         puts move.to_s
       end
       
       puts "should have:"
       @possible_ant_moves.each{|move| puts move.to_s}  
       puts "determined:"
       moves.each{|move| puts move.to_s}  
       
      puts "subset:#{@possible_ant_moves.subset? moves}"
      @possible_ant_moves.subset? moves
    end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@boardState.getPieceById(100)}
   #end  
end
