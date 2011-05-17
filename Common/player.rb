require 'boardstate'
require 'move'

class Player
  include DRbUndumped

  attr_accessor :name
  attr_accessor :gameHandler
  
  def initialize(name)
   @name = name
  end
    
  def gameStarts(message)
    puts "GAME STARTS!"
    puts "#{message}";  
  end
 
  def welcome(message)
     puts "#{message}";  
  end    
    
  def makeMove()
    puts "player's makemove called"
  end  
  
    
  

end
