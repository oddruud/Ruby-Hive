$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'
require '../Common/Insects/ant.rb'
require 'set'

describe Ant do
   
   before :each do 
     LoggerCreator.setLevel(Logger::INFO)
      @boardState = BoardState.new("test_board"){|boardState| boardState.reset}
      @white_queen = @boardState.getPiece(Piece::WHITE_QUEEN_BEE) 
      @black_spider = @boardState.getPiece(Piece::BLACK_SPIDER1) 
      @white_spider = @boardState.getPiece(Piece::WHITE_SPIDER1) 
      @black_ant = @boardState.getPiece(Piece::BLACK_ANT1) 
     
      @boardState.makeMove(Move.fromCords(@white_queen ,5,5,0)) 
      @boardState.makeMove(Move.fromRelativeCords( @black_spider, @whiteQueen, HexagonSide::BOTTOM_SIDE))
      @boardState.makeMove(Move.fromRelativeCords( @white_spider, @whiteQueen , HexagonSide::TOP_SIDE))
      @boardState.makeMove(Move.fromRelativeCords( @black_ant, @blackSpider, HexagonSide::BOTTOM_SIDE))
      
      @possibleAntMoves = [ Move.fromRelativeCords(@black_ant , @whiteQueen, HexagonSide::TOP_LEFT_SIDE), 
                            Move.fromRelativeCords(@black_ant , @whiteQueen, HexagonSide::TOP_RIGHT_SIDE)
                          ].to_set 
   end 

   # it 'should give the correct boardmoves' do
   #   moves = @blackAnt.availableMoves(@boardState)
   #   moves = moves.to_set 
   #   
   #   puts "board situation:\n #{@boardState.to_s}"
   #   
   #   puts "should have:"
   #    @possibleAntMoves.each{|move| puts move.toStringVerbose(@boardState)}  
   #   puts "determined:"
   #    moves.each do |move| 
   #      boardNext = @boardState.nextState(move)
   #      puts move.to_s + "\n"
   #      puts "next: " + boardNext.to_s
   #      puts move.toStringVerbose(boardNext)  
   #    end
   #    
   #    puts "should have:"
   #    @possibleAntMoves.each{|move| puts move.to_s}  
   #    puts "determined:"
   #    moves.each{|move| puts move.to_s}  
   #    
   #   puts "subset:#{@possibleAntMoves.subset? moves}"
   #   @possibleAntMoves.subset? moves
   # end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@boardState.getPieceById(100)}
   #end  
end
