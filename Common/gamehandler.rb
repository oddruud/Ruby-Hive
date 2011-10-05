require "boardstate"
require "player"
require 'LoggerCreator'
require 'move'

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

  def addPlayer(player)
    if @players.length < 2
      @players << player
      @logger.info "PLAYER #{@players.length}: #{player.name} added..." 
      player.setID(@players.length.to_s) 
      player.setColor(PieceColor::COLORS[player.length])
      player.submitMoveTo= lambda{|id, move| moveMade(id, move)}  
      player.welcome("the server welcomes you..wait for start signal..."); 
      start() if @players.length == 2 
    end
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
    @turn = @turn == 1 ? 0: 1 
    @players[@turn].makeMove(boardState); 
  end 
  
  def moveMade(playerID, move)
      @logger.info "#{playerID} tries move: #{move.toString}"
       
      begin  
        boardState.makeMove(move)
      rescue MoveException  
        @logger.fatal "PLAYER #{playerID} MOVE #{move.toString} INVALID"
        stop("invalid move") 
      end  
       boardState.print
      nextTurn()  
  end
  
  def stop(message)
       @logger.info "game stopped: #{message}"
  end

  
  
end