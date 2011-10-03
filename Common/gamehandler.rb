require "boardstate"
require "player"
require 'LoggerCreator'

class GameHandler
   include DRbUndumped
  
  attr_accessor :boardState 
  attr_reader :players
  attr_reader :turn
  attr_reader :updateCallback
  attr_reader :logger
  
  def initialize()
    @logger = LoggerCreator.createLoggerForClass(GameHandler)
    @players= Array.new()
    @boardState= BoardState.new("MAINBOARD")
  end

  def setUpdateCallback(&block)
     @updateCallback = block 
  end
=begin
  def test
      move= Move.new(Piece::BLACK_SPIDER1, Piece::WHITE_SPIDER1,HexagonSide::TOP_LEFT_SIDE)
     @boardState.start()
     @boardState.makeMove(move)
     moveMessage= @boardState.moveMessage(move) 
     @updateCallback.call(moveMessage)
  end
=end
  def addPlayer(player)
    
    if (@players.length < 2)
      @players << player
      @logger.info "PLAYER #{@players.length}: #{player.name} added..." 
      player.welcome("the server welcomes you..wait for start signal...");
      if (@players.length == 2)
        start();  
      end
    end
  end
  
  def moveMade(player, move)
      @logger.info "#{player.name} tries move: #{move.toString}"
    # if @boardState.makeMove(move) == true 
          @updateCallback.call()
          nextTurn()  
    # end
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