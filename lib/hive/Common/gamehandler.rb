require "boardstate"
require "player"
require 'LoggerCreator'
require 'Move/move'
require 'Move/moveexception'


class Hive::GameHandler
   include DRbUndumped
  
  attr_reader :board_state 
  attr_reader :players
  attr_reader :turn
  attr_reader :message_callback
  attr_reader :game_state_desciption 
  attr_reader :logger
  
  def initialize()
    @logger = LoggerCreator.create_logger_for_class(Hive::GameHandler)
    if block_given?
      yield self
    end
  end

  def create_new_game
    @players = Array.new()
    @interval_time = 0.5
    @game_state_description = "Fresh game, waiting for players to connect..." 
    @board_state = Hive::BoardState.new("MAINBOARD")
    #sendMessage("GI.#{board_state::BOARD_SIZE}.#{board_state::BOARD_SIZE}.")
  end

  def set_update_callback(&block)
     @message_callback = block 
  end
  
  def set_state_description(text)
 	 @game_state_description = text 
  end
  
  def get_state_description
 	 return @game_state_description 
  end
  
  def add_player(player)
    if @players.length < 2
      @players << player
      @logger.info "PLAYER #{@players.length}: #{player.name} added..." 
      set_state_description("PLAYER #{@players.length}: #{player.name} connected..." )
      player.set_i_d(@players.length.to_s) 
      player.set_color(Hive::PieceColor::COLORS[@players.length-1])
      player.set_submit_function( Proc.new{|player, move| move_made(player, move)} ) 
      player.welcome("the server welcomes you..wait for start signal..."); 
      @ready_to_start = true if @players.length == 2
    end
  end
  
  def ready_to_start?()
    return @ready_to_start
  end
  
  def remove_player_with_id(id)
    @player.delete_if {|player| player.id == id} 
  end
  
  def get_piece(id)  
  	piece = @board_state.get_piece_by_id id
	return piece
  end 
  
  def start() 
    raise "game handler not ready to start" if not ready_to_start?
    @turn = 1 
    welcome = "#{@players[0].name} VS  #{@players[1].name}";
    set_state_description(welcome)
    send_message("GB.#{welcome}.")
    @players.each { |p| p.game_starts(welcome) }
    next_turn()    
  end

  private 

  def next_turn()
   send_message(@board_state.to_message)
    @turn = @turn == 1 ? 0: 1 
    puts "sleeping..."
    sleep(interval_time)
    player = @players[@turn]
    puts "TURN TO: player #{player.name} (#{player.color})"
    player.make_move(board_state); 
  end 
  
  def interval_time
    return @interval_time
  end
  
  def game_over()
    @logger.info "GAME OVER"
    winner = player_by_color(@board_state.color_of_winner())
    @logger.info "#{winner.to_s} wins"
    send_message("GO.#{winner.id}.")
  end
  
  def player_by_color(color)
    players.each do |player|
      if player.color == color
        return player 
      end
    end
    return nil 
  end
  
  def move_made(player, move)
      begin  
        raise "move is null" if move.nil?
        @logger.info "#{player} tries move: #{move}" unless move.nil?
      	raise "#{player} tried to move piece #{move.piece} from opposing color" unless player.color == move.color 
        result = @board_state.make_move(player, move)
        
        case result 
          when Hive::TurnState::GAME_OVER then 
            game_over()
          when Hive::TurnState::VALID then 
            next_turn()  
          when Hive::TurnState::INVALID then
            stop("invalid move: #{move}")
        end
      rescue Exception  => detail
        @logger.fatal "move failed: #{detail.message}"
        puts detail.backtrace[0..5].join("\n")
        stop("invalid move") 
      end  
  end
  
  def send_message(message)
     @message_callback.call(message) unless @message_callback.nil?
  end
  
  def stop(message)
       @logger.info "game stopped: #{message}"
       send_message("GS.#{message}.")
  end

  
  
end