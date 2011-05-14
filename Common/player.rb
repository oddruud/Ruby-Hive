require 'boardstate'
class Player
  include DRbUndumped
  attr_accessor :name
  
  def initialize(name)
   @name = name
  end
    
  def submitMove(boardState)
    puts "Submitting move..."
    return "this is my move!"
  end

end
