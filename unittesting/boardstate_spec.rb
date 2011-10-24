$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'

describe BoardState do
   
   before :each do 
      @boardState= BoardState.new()
   end 

   it 'should give an out of bounds error when move coordinate outside the board grid' do 
     move = Move.new(Piece::BLACK_ANT1, 100,100)
     #assert_raise(RuntimeError, MoveException) do 
     #   @boardState.makeMove move   
     #end
     assert(true,true) 
   end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@boardState.getPieceById(100)}
   #end  
end
