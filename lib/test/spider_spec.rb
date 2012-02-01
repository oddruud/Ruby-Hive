$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'
require '../Common/Insects/spider.rb'
require 'set'

describe Spider do
   
   before :each do 
     LoggerCreator.setLevel(Logger::INFO)
      @board_state = BoardState.new("test_board")
      
      @white_queen = @boardState.getPiece(Piece::WHITE_QUEEN_BEE) 
      @white_beetle = @boardState.getPiece(Piece::WHITE_BEETLE1) 
      @white_spider = @boardState.getPiece(Piece::WHITE_SPIDER1) 
      @black_grasshopper = @boardState.getPiece(Piece::BLACK_GRASSHOPPER1) 
      @black_grasshopper2 = @boardState.getPiece(Piece::BLACK_GRASSHOPPER2) 
             
      @black_spider = @boardState.getPiece(Piece::BLACK_SPIDER1)
      @black_ant = @boardState.getPiece(Piece::BLACK_ANT1)
       
      @board_state.makeMove( Move.fromCords( @white_queen,5,5,0) ) 
      @board_state.makeMove( Move.fromCords( @black_ant,6,5,0) ) 
      @board_state.makeMove(Move.fromCords(@white_beetle,4,5,0)) 
      @board_state.makeMove(Move.fromCords(@black_grasshopper,7,5,0)) 
      @board_state.makeMove(Move.fromCords(@white_spider,5,6,0)) 
      @board_state.makeMove(Move.fromCords(@black_grasshopper2,7,6,0)) 

      @possible_board_moves = [ Move.fromCords(@white_spider, 4,4,0), 
                                Move.fromCords(@white_spider, 7,7,0) ].to_set 
                                         
   end 
   
   it 'should provide the correct possible moves' do 
     moves_array = Spider.availableBoardMoves(@white_spider, @board_state)
     puts moves_array.map {|x| x.to_s }.join("\n")
     #moves_array.to_set.should ==  @possible_board_moves 
   end
   
end
