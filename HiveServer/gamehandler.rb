require "boardstate"
class GameHandler
  attr_reader :value
  attr_reader :boardState 
  attr_reader :players
  
  def initialize
    @players= Array.new()
    @boardState= BoardState.new()
    @value = 0 
  end
  
  def hello
    puts "HELLO"
  end
  
  def addPlayer(player)
    @players.push(player)
    puts "#{player.name} added..."
  end
  
end