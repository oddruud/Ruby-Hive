require "boardstate"
require "player"

class GameHandler
   include DRbUndumped
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
    move = player.submitMove(@boardState)
    puts "response #{move}" 
  end
  
end