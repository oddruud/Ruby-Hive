require "socket"  
require "boardstate"  

class Server
  
  attr_reader :dts
  attr_reader :boardState
  
  def initialize
    @boardState= BoardState.new()
    @dts = TCPServer.new('localhost', 3333)  
    puts "start server"
    puts "localhost:3333" 
    listen() 
  end
  
  
 
def listen  
  loop do  
    Thread.start(@dts.accept) do |s|  
      print(s, " is accepted\n")  
      s.write(Time.now)    
    end   
  end  
end

def handleMessage(message)
  
end
  
  
  
  
end