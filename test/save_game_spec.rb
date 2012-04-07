require '../test/test_utils'
require 'set'

describe Hive::SaveGame do
   
before :each do 
  @game = Hive::Game.new()
  @test_save = @game.save("../saves", "load_test")
  Logger.set_level(Logger::INFO)
end
  
it 'should save correctly TEST1'
  save_game = @game.save("../saves", "save_test") 
  puts save_game.to_s
end    
        
it 'should load save_game from file correctly'
 load_save_game = Hive::SaveGame.load_from_file(@test_save.file_path) 
 puts save_game.to_s
end

it 'should load a game correctly'
  loaded_game = Hive::Game.load( @test_save ) 
  puts loaded_game.to_s
end

it 'should load a game from file correctly' 
  loaded_game = Hive::Game.load_from_file( @test_save.file_path ) 
  puts loaded_game.to_s
end

end