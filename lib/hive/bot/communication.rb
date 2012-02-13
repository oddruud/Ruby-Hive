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
  game_handler = DRbObject.new nil, uri
  game_handler.hello() 
  puts ("initing communication object (DRb): #{uri}")
end


def retrieve_message(message)
  
end

def send_message(message)
  
end  

def send_move(move)
  
end
  
  
end