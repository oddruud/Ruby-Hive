$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'
require '../Common/Insects/ant.rb'
require 'set'

describe BoardState do
   
   before :each do 
     LoggerCreator.setLevel(Logger::INFO)
      @boardState = BoardState.new()
      @whiteQueen = @boardState.getPiece(Piece::WHITE_QUEEN_BEE) 
      @blackSpider = @boardState.getPiece(Piece::BLACK_SPIDER1) 
      @whiteSpider = @boardState.getPiece(Piece::WHITE_SPIDER1) 
      @blackAnt = @boardState.getPiece(Piece::BLACK_ANT1) 
     
      @boardState.makeMove(Move.fromCords(Piece::WHITE_QUEEN_BEE,5,5,0)) 
      @boardState.makeMove(Move.fromRelativeCords(Piece::BLACK_SPIDER1, @whiteQueen, HexagonSide::BOTTOM_SIDE))
      @boardState.makeMove(Move.fromRelativeCords(Piece::WHITE_SPIDER1, @whiteQueen , HexagonSide::TOP_SIDE))
      @boardState.makeMove(Move.fromRelativeCords(Piece::BLACK_ANT1, @blackSpider, HexagonSide::BOTTOM_SIDE))
      
      @possibleAntMoves = [ Move.fromRelativeCords(Piece::BLACK_ANT1, @whiteQueen, HexagonSide::TOP_LEFT_SIDE), 
                            Move.fromRelativeCords(Piece::BLACK_ANT1, @whiteQueen, HexagonSide::TOP_RIGHT_SIDE)
                          ].to_set 
   end 

   it 'should give the correct boardmoves' do
     moves = @blackAnt.availableMoves(@boardState)
     moves = moves.to_set 
     
     puts "board situation:\n #{@boardState.to_s}"
     
     puts "should have:"
      @possibleAntMoves.each{|move| puts move.toStringVerbose(@boardState)}  
     puts "determined:"
      moves.each{|move| puts move.toStringVerbose(@boardState)} 
      
      puts "should have:"
      @possibleAntMoves.each{|move| puts move.to_s}  
      puts "determined:"
      moves.each{|move| puts move.to_s}  
      
     puts "subset:#{@possibleAntMoves.subset? moves}"
     @possibleAntMoves.subset? moves
   end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@boardState.getPieceById(100)}
   #end  
end
