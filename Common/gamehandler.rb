require "boardstate"
require "player"
require 'LoggerCreator'
require 'move'
require 'moveexception'


class GameHandler
   include DRbUndumped
  
  attr_accessor :boardState 
  attr_reader :players
  attr_reader :turn
  attr_reader :messageCallback
  attr_reader :logger
  
  def initialize()
    @logger = LoggerCreator.createLoggerForClass(GameHandler)
    if block_given?
      yield self
    end
  end

  def createNewGame
    @players = Array.new()
    @boardState= BoardState.new("MAINBOARD")
    sendMessage("GI.#{BoardState::BOARD_SIZE}.#{BoardState::BOARD_SIZE}.")
  end

  def setUpdateCallback(&block)
     @messageCallback = block 
  end

  def addPlayer(player)
    if @players.length < 2
      @players << player
      @logger.info "PLAYER #{@players.length}: #{player.name} added..." 
      player.setID(@players.length.to_s) 
      player.setColor(PieceColor::COLORS[@players.length-1])
      player.submitMoveTo = Proc.new{|id, move| moveMade(id, move)}  
      player.welcome("the server welcomes you..wait for start signal..."); 
      sendMessage("PA.#{player.id}.#{player.name}.")
      start() if @players.length == 2 
    end
  end
  
  def removePlayerWithId(id)
    @player.delete_if {|player| player.id == id} 
  end
  

  private 
  
  def start() 
    @turn = 1 
    welcome = "#{@players[0].name} VS  #{@players[1].name}";
    sendMessage("GB.#{welcome}.")
    @players.each do |p|
      p.gameStarts(welcome)
    end 
    
    nextTurn()    
  end  
  
  def nextTurn()
   sendMessage(@boardState.to_message)
    if boardState.moveCount > 21
      raise "breakpoint"
    end
    
    @turn = @turn == 1 ? 0: 1 
    @players[@turn].makeMove(boardState); 
  end 
  
  def gameOver()
    @logger.info "GAME OVER"
    winner = playerByColor(@boardState.colorOfWinner())
    @logger.info "#{winner.to_s} wins"
    sendMessage("GO.#{winner.id}.")
  end
  
  def playerByColor(color)
    players.each do |player|
      if player.color == color
        return player 
      end
    end
    return nil 
  end
  
  
  def moveMade(playerID, move)
      begin  
        raise "move is null" if move.nil?
       @logger.info "#{playerID} tries move: #{move.toString}" unless move.nil?
       
        sendMessage(move.to_message)
        result = boardState.makeMove(move)
        @logger.debug boardState.to_s
        
        case result 
        when TurnState::GAME_OVER then 
          gameOver()
        when TurnState::VALID then 
          nextTurn()  
        when TurnState::INVALID then
          stop("invalid move: #{move.to_s}")
        end
      rescue Exception  => detail
        @logger.fatal "move failed: #{detail.message}"
        puts detail.backtrace[0..5].join("\n")
        stop("invalid move") 
      end  
  end
  
  def sendMessage(message)
     @messageCallback.call(message)
  end
  
  def stop(message)
       @logger.info "game stopped: #{message}"
       sendMessage("GS.#{message}.")
  end

  
  
end