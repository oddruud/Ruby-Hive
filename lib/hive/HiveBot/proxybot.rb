require "Common/bot"
require "LoggerCreator"

class Hive::ProxyBot < Hive::Bot
      include DRbUndumped
  
  attr_reader :active
  attr_reader :socket
  
  def initialize(name, socket)
    super("Proxy Bot:#{name}")   
    @socket = socket
  end
  
  def activate
     @active = true
     listen_thread = Thread.new{listen()}
     listen_thread.join()
  end
 
  def determine_next_move(board_state)
    @logger.debug "calculating move for #{@color}.."
    @socket.puts "your turn"
  end
  
  private 
  
  def listen()
    while(@active) do 
      message = @socket.gets 
      handle_message(message) 
    end   
  end
  
  def handle_message(message) 
    @logger.debug "message received: #{message}"
    submit_move(Move.new(-1,-1,-1))
  end
  
end
