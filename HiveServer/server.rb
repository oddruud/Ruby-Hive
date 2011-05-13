require "socket"  
require "drb"
require "gamehandler"  

class Server
  
  attr_reader :dts
  attr_reader :gameHandler
  
  def initialize(url, port)
    @gameHandler= GameHandler.new()
    @url = url
    @port= port  
    DRb.start_service "druby://"+url+":"+ port, @gameHandler    
    puts "Server running at #{DRb.uri}"
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