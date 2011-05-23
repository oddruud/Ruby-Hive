require "socket"  
require "drb"
require "gamehandler"  
require "move"
class Server
  
  attr_reader :dts
  attr_reader :gameHandler
  
  def initialize(url, port)
    @gameHandler= GameHandler.new()
    @url = url
    @port= port  
    DRb.start_service "druby://"+url+":"+ port, @gameHandler    
    puts "Server running at #{DRb.uri}"
    
    move = Move.new(Piece::WHITE_SPIDER1, -1,-1)
    move2= Move.new(Piece::BLACK_SPIDER1, Piece::WHITE_SPIDER1,HexagonSide::TOP_LEFT_SIDE)
    puts move.toString()
    @gameHandler.boardState.start()
    @gameHandler.boardState.makeMove(move)
    @gameHandler.boardState.makeMove(move2)
    @gameHandler.boardState.print()
    DRb.thread.join
  end
    
def listen  
  #loop do  
  #  Thread.start(@dts.accept) do |s|  
  #    print(s, " is accepted\n")  
  #    s.write(Time.now)    
  #  end   
  #end  
end

def handleMessage(message)
  
end
  
  
  
  
end