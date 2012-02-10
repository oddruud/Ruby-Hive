$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), '../lib/' ) )

require 'hive.rb'
require 'set'

describe Hive::Spider do
   
   before :each do 
     LoggerCreator.setLevel(Logger::INFO)
                                         
   end 
   
   it 'should provide the correct possible moves' do 
     moves_array = Spider.availableBoardMoves(@white_spider, @board_state)
     puts moves_array.map {|x| x.to_s }.join("\n")
     #moves_array.to_set.should ==  @possible_board_moves 
   end
   
end
