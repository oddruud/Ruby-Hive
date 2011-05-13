require "boardstate"
class GameHandler
  attr_reader :value
  attr_reader :boardState 
  
  def initialize
    @boardState= BoardState.new()
    @value = 0 
  end
  
  def hello
    puts "HELLO"
  end
  
end