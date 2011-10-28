$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/Insects' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../Common/MoveValidators' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '..' ) )

require '../Common/boardstate.rb'

describe BoardState do
   
   before :each do 
      @boardState= BoardState.new("test_board"){|boardState| boardState.reset}
   end 

   it 'should give an out of bounds error when move coordinate outside the board grid' do 
     move = Move.fromCords(Piece::BLACK_ANT1, 10,10,1)
     move.should_not eql(nil)
   end
  
   it 'should have unique piece ids in board' do
     
   end
  
   it 'should make a correct deep copy' do
      clone = @boardState.clone
      
      #check all pieces

      #check board
      
      #check moves
      puts clone.to_s
      puts @boardState.to_s
   end
  
   #should 'raise an exception when a piece id does not match a piece' do 
   #   assert_raise(RuntimeError){@boardState.getPieceById(100)}
   #end  
end
