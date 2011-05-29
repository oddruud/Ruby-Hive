require "socket"  
require "drb"
require "gamehandler"  
require "move"
class Server
  
  attr_reader :dts
  attr_reader :server
  attr_reader :running
  attr_reader :gameHandler
  
  def initialize(url, port)
    @running = true
    @gameHandler= GameHandler.new()
    @url = url
    @port= port  
    DRb.start_service "druby://"+url+":"+ port, @gameHandler    
    puts "Distrbuted Ruby Server running at #{DRb.uri}"  
    tcpport= 8899
    @server = TCPServer.open(tcpport)  # Socket to listen on port 2000
    puts "TCP Server running at port #{tcpport.to_s}"
    serverThread = Thread.new{ listen();}
    
    DRb.thread.join
    serverThread.join 
    
  end
    
    
def tests
    move = Move.new(Piece::WHITE_SPIDER1, -1,-1)
    move2= Move.new(Piece::BLACK_SPIDER1, Piece::WHITE_SPIDER1,HexagonSide::TOP_LEFT_SIDE)
    puts move.toString()
    @gameHandler.boardState.start()
    @gameHandler.boardState.makeMove(move)
    @gameHandler.boardState.makeMove(move2)
    @gameHandler.boardState.print()
end
      
    
def listen2  
  #loop do  
  #  Thread.start(@dts.accept) do |s|  
  #    print(s, " is accepted\n")  
  #    s.write(Time.now)    
  #  end   
  #end  
end

def listen  
    puts "tcp server is listening..."
    while @running do                        # Servers run forever
      while session = @server.accept do 
        Thread.start do
          session.puts(Time.now.ctime)  # Send the time to the client
          session.puts "Hi there"
          puts "someone connected"
          input = session.gets
          puts input
          client.close                 # Disconnect from the client
        end
      end
    end
end



def handleMessage(message)
  
end
  
  
  
  
end