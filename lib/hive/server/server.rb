require "socket"  
require "drb"
require "move/move"
require "bot/naive_bot"


class Hive::Server
  
  attr_reader :dts
  attr_reader :server
  attr_reader :sockets
  attr_reader :running
  attr_reader :game
  attr_reader :players
  attr_reader :logger
  
  def initialize(port, test_mode)
    @logger = Logger.new_for_class(Hive::Server) 
    @running = true
    @sockets = Array.new() 
    @game = Hive::Game.new() do |g| 
        g.set_update_callback() {|message| update_viewers(message)} 
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
    
    #Distributed Ruby server for connection with game player client------- 
    #DRb.start_service "druby://localhost:#{port}", @game_handler  
    #@logger.info "Distrbuted Ruby Server running at #{DRb.uri}"  
    #DRb.thread.join   
  end
   


def create_proxy_bot( name, socket )
  bot = Hive::ProxyBot.new(name, socket)
end

def add_player( player )
  game.add_player player unless game.full?
end

def start_game 
  game.start
end

def start_test()
    @game.add_player Hive::NaiveBot.new("testbot1")
    @game.add_player Hive::NaiveBot.new("testbot2")
    @game.start()
end   
   
   
def update_viewers(game_message)
  #@logger.info "updating all game viewers with message #{game_message}"
  @sockets.each do |socket|
    socket.puts game_message
  end
end

#hive game viewer clients listen thread
#TODO handle incoming tcp player bots
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



def handle_message(message)
  
end
  
  
  
  
end
