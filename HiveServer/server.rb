require "socket"  
require "drb"
require "gamehandler"  
require "move"
require "LoggerCreator"

class Server
  
  attr_reader :dts
  attr_reader :server
  attr_reader :sockets
  attr_reader :running
  attr_reader :gameHandler
  attr_reader :logger
  def initialize(port)
    @logger = LoggerCreator.createLoggerForClass(Server) 
    @running = true
    @sockets = Array.new() 
    @gameHandler= GameHandler.new()
    @gameHandler.setUpdateCallback() {|message| updateViewers(message)}
    @port = port  
   
    

    #---------------------------------------------------------------------
   
    #TCP server for communication with game viewer client------------- 
    #tcpport= 8899
   # @server = TCPServer.open(tcpport)
    #puts "TCP Server running at port #{tcpport.to_s}"
    #serverThread = Thread.new{ listen();}
    #-----------------------------------------------------------------
    
    #serverThread.join 
    # puts "DRB"
    tests 
    
    #Distributed Ruby server for connection with game player client------- 
    #DRb.start_service "druby://localhost:#{port}", @gameHandler  
    #puts "Distrbuted Ruby Server running at #{DRb.uri}"  
    #DRb.thread.join   
  end
    
    
def tests
    @logger.info "running tests"
    move = Move.new(Piece::WHITE_SPIDER1, -1,-1)
    move2= Move.new(Piece::BLACK_SPIDER1, Piece::WHITE_SPIDER1,HexagonSide::TOP_LEFT_SIDE)
    move3= Move.new(Piece::WHITE_SPIDER2, Piece::WHITE_SPIDER1,HexagonSide::BOTTOM_RIGHT_SIDE)
    @gameHandler.boardState.start()
    @gameHandler.boardState.makeMove(move)
    @gameHandler.boardState.print()
    @gameHandler.boardState.makeMove(move2)
    @gameHandler.boardState.print()
    @gameHandler.boardState.makeMove(move3)
    @gameHandler.boardState.print()
    
end


def updateViewers(gameMessage)
  @logger.info "updating all game viewers with message #{gameMessage}"
  @sockets.each do |socket|
    socket.puts gameMessage
  end
end


#hive game viewer clients listen thread
def listen  
    @logger.info "tcp server is listening..."
    while @running do                        # Servers run forever
      while session = @server.accept do 
        sockets << session
        Thread.start do
          session.puts(Time.now.ctime)  # Send the time to the client
          session.puts("Hello hive game viewer\n")
          #session.puts "Hi there"
          @logger.info "someone connected"
          Thread.start do
           while true do
              input = session.gets
              @logger.info input
              session.puts "you said #{input}"
            end
          end 
          #userinput = gets 
          #puts "sending #{userinput}"
          #session.puts("#{userinput}\n")
        end
      end
    end
end



def handleMessage(message)
  
end
  
  
  
  
end