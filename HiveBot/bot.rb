class Bot
  require 'communication'   
  require 'boardstate'
  attr_reader :com 
  attr_reader :boardState

  def initialize()
      host = "localhost"
      port= "3333"
      @boardState = BoardState.new()
      @com = Communication.new(host, port)
      mainLoop()   
  end
  
  def mainLoop
   while(true)
  
  
    end
end

      
  
  
end
