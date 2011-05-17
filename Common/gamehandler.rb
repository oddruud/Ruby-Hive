require "boardstate"
require "player"

class GameHandler
   include DRbUndumped
  
  attr_reader :value
  attr_reader :boardState 
  attr_reader :players
  attr_reader :turn
  
  def initialize
    @players= Array.new()
    @boardState= BoardState.new()
    @value = 0 
  end

  def addPlayer(player)
    
    if (@players.length < 2)
      @players << player
      puts "PLAYER #{@players.length}: #{player.name} added..." 
      player.welcome("the server welcomes you..wait for start signal...");
      if (@players.length == 2)
        start();  
      end
    end
  end
  
  def moveMade(player, move)
     puts "#{player.name} made move #{move.toString}"
     nextTurn()  
  end
  
  private 
  
  def start()
    @players
    @turn = 0  
    welcome = "#{@players[0].name} VS  #{@players[1].name}";
    @players.each do |p|
      p.gameStarts(welcome)
    end 
    nextTurn()    
  end  
  
  def nextTurn()
    if @turn != 0 
      @turn = 0 
    else 
      @turn = 1 
    end
    @players[@turn].makeMove(); 
  end 
  
  
end