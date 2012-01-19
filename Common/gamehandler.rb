require "boardstate"
require "player"
require 'LoggerCreator'
require 'Move/move'
require 'Move/moveexception'


class GameHandler
   include DRbUndumped
  
  attr_reader :board_state 
  attr_reader :players
  attr_reader :turn
  attr_reader :message_callback
  attr_reader :game_state_desciption 
  attr_reader :logger
  
  def initialize()
    @logger = LoggerCreator.createLoggerForClass(GameHandler)
    if block_given?
      yield self
    end
  end

  def createNewGame
    @players = Array.new()
    @interval_time = 0.5
    @game_state_description = "Fresh game, waiting for players to connect..." 
    @board_state = BoardState.new("MAINBOARD")
    #sendMessage("GI.#{board_state::BOARD_SIZE}.#{board_state::BOARD_SIZE}.")
  end

  def setUpdateCallback(&block)
     @message_callback = block 
  end
  
  def setStateDescription(text)
 	 @game_state_description = text 
  end
  
  def getStateDescription
 	 return @game_state_description 
  end
  
  def addPlayer(player)
    if @players.length < 2
      @players << player
      @logger.info "PLAYER #{@players.length}: #{player.name} added..." 
      setStateDescription("PLAYER #{@players.length}: #{player.name} connected..." )
      player.setID(@players.length.to_s) 
      player.setColor(PieceColor::COLORS[@players.length-1])
      player.submitMoveTo = Proc.new{|id, move| moveMade(id, move)}  
      player.welcome("the server welcomes you..wait for start signal..."); 
      #sendMessage("PA.#{player.id}.#{player.name}.")
      @ready_to_start = true if @players.length == 2
      #TODO send a signal 
    end
  end
  
  def readyToStart?()
    return @ready_to_start
  end
  
  def removePlayerWithId(id)
    @player.delete_if {|player| player.id == id} 
  end
  
  def getPiece(id, turn)  
  	piece = @board_state.getPieceById id
  	x, y, z = piece.boardPosition
  	#todo add support to retrieve coordinates from previous turns 
	return piece
  end 
  
  def start() 
    raise "game handler not ready to start" if not readyToStart?
    @turn = 1 
    welcome = "#{@players[0].name} VS  #{@players[1].name}";
    setStateDescription(welcome)
    sendMessage("GB.#{welcome}.")
    @players.each { |p| p.gameStarts(welcome) }

    nextTurn()    
  end

  private 

  def nextTurn()
   sendMessage(@board_state.to_message)
    #if board_state.moveCount > 21
    #  raise "breakpoint"
    #end
    @turn = @turn == 1 ? 0: 1 
    puts "sleeping..."
    sleep(intervalTime)
    puts "New move"
    @players[@turn].makeMove(board_state); 
  end 
  
  def intervalTime
    return @interval_time
  end
  
  def gameOver()
    @logger.info "GAME OVER"
    winner = playerByColor(@board_state.colorOfWinner())
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
       
        #sendMessage(move.to_message)
        result = board_state.makeMove(move)
        
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
     @message_callback.call(message) unless @message_callback.nil?
  end
  
  def stop(message)
       @logger.info "game stopped: #{message}"
       sendMessage("GS.#{message}.")
  end

  
  
end