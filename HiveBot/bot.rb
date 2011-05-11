class Bot
  require 'communication'   
  require 'Insects/ant'  
  require 'boardstate'
  attr_reader :com 
  attr_reader :piece
  attr_reader :boardState

  def initialize()
      host = "localhost"
      port= "3333"
      @piece= Ant.new()
     
      @com = Communication.new(host, port)
      mainLoop()   
  end
  
  def mainLoop
   while(true)
  
  
    end
end

      
  
  
end
