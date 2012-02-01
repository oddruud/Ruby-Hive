class Communication
attr_reader :port
attr_reader :host
attr_reader :socket
attr_reader :active

require 'drb'
 
def initialize(host, port)
  @active= true
  @host= host
  @port= port
  uri= "druby://#{host}:#{port}"  
  gameHandler = DRbObject.new nil, uri
  gameHandler.hello() 
  puts ("initing communication object (DRb): #{uri}")
end


def retrieveMessage(message)
  
end

def sendMessage(message)
  
end  

def sendMove(move)
  
end
  
  
end