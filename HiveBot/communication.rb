class Communication
attr_reader :port
attr_reader :host
attr_reader :socket
attr_reader :active

require 'socket'      # Sockets are in standard library
    
def initialize(host, port)
  @active= true
  @host= host
  @port= port
  @socket = TCPSocket.new(@host, @port)
  @socket.print("hello server\n")
  startListener()
end

def startListener    
     Thread.start do  
     while  !( @socket.closed?) && (serverMessage =  @socket.gets)
        puts serverMessage
        @socket.print("thanks server\n")
      end  
  end
  
end

def retrieveMessage(message)
  
end

def sendMessage(message)
  
end  

def sendMove(move)
  
end
  
  
end