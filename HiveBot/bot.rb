class Bot
  require 'communication'   
  attr_reader :com
  
  def initialize()
      host = "localhost"
      port= "3333"
      @com = Communication.new(host, port)
      mainLoop()   
  end
  
  def mainLoop
   while(true)
  
  
    end
end

      
  
  
end