require "socket"  
require "drb"
require "gamehandler"  
require "move"
require "LoggerCreator"
require "HiveBot/naivebot"

class Server
  
  attr_reader :dts
  attr_reader :server
  attr_reader :sockets
  attr_reader :running
  attr_reader :gameHandler
  attr_reader :logger
  
  def initialize(port, testMode)
    @logger = LoggerCreator.createLoggerForClass(Server) 
    @running = true
    @sockets = Array.new() 
    @gameHandler= GameHandler.new() do |gh| 
        gh.setUpdateCallback() {|message| updateViewers(message)}
        gh.createNewGame()
    end
    @port = port  
   
 
    #---------------------------------------------------------------------
   
    #TCP server for communication with game viewer client------------- 
    #tcpport= 8899
   # @server = TCPServer.open(tcpport)
    #puts "TCP Server running at port #{tcpport.to_s}"
    #serverThread = Thread.new{ listen();}
    #-----------------------------------------------------------------  
    #serverThread.join 
    
    
    if testMode
      @gameHandler.addPlayer NaiveBot.new("testbot1")
      @gameHandler.addPlayer NaiveBot.new("testbot2")
    end
 
 
    #Distributed Ruby server for connection with game player client------- 
    #DRb.start_service "druby://localhost:#{port}", @gameHandler  
    #@logger.info "Distrbuted Ruby Server running at #{DRb.uri}"  
    #DRb.thread.join   
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