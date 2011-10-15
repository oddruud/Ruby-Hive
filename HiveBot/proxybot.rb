require "Common/bot"
require "LoggerCreator"

class ProxyBot < Bot
      include DRbUndumped
  
  attr_reader :active
  attr_reader :socket
  
  def initialize(name, socket)
    super("Proxy Bot:#{name}")   
    @socket = socket
  end
  
  def activate
     @active = true
     listenThread = Thread.new{listen()}
     listenThread.join()
  end
 
  def determineNextMove(boardState)
    @logger.debug "calculating move for #{@color}.."
    @socket.puts "your turn"
  end
  
  private 
  
  def listen()
    while(@active) do 
      message = @socket.gets 
      handleMessage(message) 
    end   
  end
  
  def handleMessage(message) 
    @logger.debug "message received: #{message}"
    submitMove(Move.new(-1,-1,-1))
  end
  
end
