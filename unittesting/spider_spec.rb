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
      
      @board_state.makeMove(Move.fromCords(Piece::WHITE_QUEEN_BEE,5,5,0)) 
      @board_state.makeMove(Move.fromCords(Piece::BLACK_ANT1,6,5,0)) 
      @board_state.makeMove(Move.fromCords(Piece::WHITE_BEETLE1,4,5,0)) 
      @board_state.makeMove(Move.fromCords(Piece::BLACK_GRASSHOPPER1,7,5,0)) 
      @board_state.makeMove(Move.fromCords(Piece::WHITE_SPIDER1,5,6,0)) 
      @board_state.makeMove(Move.fromCords(Piece::BLACK_GRASSHOPPER2,7,6,0)) 

      @possible_board_moves = [ Move.fromCords(Piece::WHITE_SPIDER1,4,4,0), 
                                Move.fromCords(Piece::WHITE_SPIDER1,7,7,0) ].to_set 
                          
      @white_spider1 = @board_state.getPieceById(Piece::WHITE_SPIDER1)                    
   end 
   
   it 'should provide the correct possible moves' do 
     moves_array = Spider.availableBoardMoves(@white_spider1, @board_state)
     puts moves_array.map {|x| x.to_s }.join("\n")
     #moves_array.to_set.should ==  @possible_board_moves 
   end
   
end
